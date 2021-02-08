9 Adding observability with containerized monitoring
  - monitoring with Docker: exposing metrics from your application containers and using Prometheus to collect them and Grafana to visualize them in user-friendly dashboards.

9.1 The monitoring stack for containerized applications
  - Prometheus runs in a Docker container, so you can easily add a monitoring stack to your applications.
  - Prometheus image uses the DOCKER_ HOST IP address to talk to your host machine and collect the metrics you’ve configured in the Docker Engine.
  - The Prometheus UI shows all the information from Docker’s /metrics endpoint, and you can filter the metrics and display them in tables or graphs.
  - Prometheus will store enough information for you to build a dashboard that shows the overall health of the whole system.

9.2 Exposing metrics from your application
  - The information points collected from a Prometheus client library are runtime-level metrics.

9.3 Running a Prometheus container to collect metrics
  - Recording extra information with labels is one of the most powerful features of Prometheus. It lets you work with a single metric at different levels of granularity.
  - Prometheus has a query language called PromQL

9.4 Running a Grafana container to visualize metrics
  - The Grafana dashboard conveys key information across many different levels of the application.

9.5 Understanding the levels of observability
  - Part of the magic of Docker is the huge ecosystem that’s grown around containers, and the patterns that have emerged around that ecosystem.
