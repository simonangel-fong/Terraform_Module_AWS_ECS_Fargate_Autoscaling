import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.BASE_URL || "http://127.0.0.1:8080";

const MAX = __ENV.MAX || 300;
const AVG = 100;

const SLA_FAIL = __ENV.SLA_FAIL || "0.01";
const SLA_DUR_99 = __ENV.SLA_DUR_99 || "1000";

export const options = {
  thresholds: {
    http_req_failed: [{ threshold: `rate<${SLA_FAIL}`, abortOnFail: true }], // SLA: http errors < 1%; otherwise abort the test
    http_req_duration: [`p(99)<${SLA_DUR_99}`], // SLA: http 99% of requests < 1s
  },
  scenarios: {
    // name of scenario
    average_load: {
      executor: "ramping-vus",
      stages: [
        { duration: "30s", target: MAX },
        { duration: "60s", target: MAX },
        { duration: "30s", target: 0 },
      ],
    },
  },
};

// Smoke testing
export default () => {
  // home
  const homeRes = http.get(BASE_URL);
  check(homeRes, { "status returned 200": (r) => r.status == 200 });

  sleep(1);
};
