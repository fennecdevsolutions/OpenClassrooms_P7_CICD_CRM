# ====================================================
# STAGE 1 : Frontend Compilation
# ====================================================
FROM node:20-alpine AS front-build
WORKDIR /src
# Copy dependency file
COPY front/package*.json ./
# Install dependencies
RUN npm ci
# Copy the source code and build
COPY front/ .
RUN npx @angular/cli build --configuration production

# ====================================================
# STAGE 2 : Backend Compilation
# ====================================================
FROM gradle:jdk17 AS back-build
WORKDIR /src
# Copy gradle files 
COPY back/build.gradle back/settings.gradle ./
COPY back/gradle/ gradle/
COPY back/gradlew ./
RUN cat -A gradlew | head -3
# Install dependencies
RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon || true
# Copy the source code and build JAR 
COPY back/ .
RUN ./gradlew bootJar --no-daemon

# ====================================================
# STAGE 3 : Caddy server execution (front)
# ====================================================
FROM caddy:2-alpine AS frontend
# Use default caddy user for minila privileges
RUN addgroup -S oriongroup && adduser -S orionuser -G oriongroup

WORKDIR /app
# Copy compiled files
COPY misc/docker/Caddyfile /etc/caddy/Caddyfile
COPY --from=front-build /src/dist/microcrm/browser /app/front

RUN chown -R orionuser:oriongroup /app /etc/caddy /config /data
USER orionuser

EXPOSE 80
EXPOSE 443

# ====================================================
# STAGE 4 : Java JRE execution (back)
# ====================================================
FROM eclipse-temurin:17-jre-alpine AS backend
# Creation of a new group and user with minimal privileges
RUN addgroup -S oriongroup && adduser -S orionuser -G oriongroup
USER orionuser
WORKDIR /app
# Copy and execute JAR file
COPY --from=back-build /src/build/libs/*-SNAPSHOT.jar /app/microcrm.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/microcrm.jar"]