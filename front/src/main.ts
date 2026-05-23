import { bootstrapApplication } from '@angular/platform-browser';
import { init as initApm } from '@elastic/apm-rum';
import { AppComponent } from './app/app.component';
import { appConfig } from './app/app.config';

const apm = initApm({
  serviceName: 'orion-frontend',

  // APM container URL
  serverUrl: 'http://localhost:8200',

  // Activate HTTP requests capture for analysis
  distributedTracingOrigins: ['http://localhost:8080']
})

bootstrapApplication(AppComponent, appConfig)
  .catch((err) => console.error(err));


