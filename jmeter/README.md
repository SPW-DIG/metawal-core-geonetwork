# Load testing

Load tests are made using [Apache JMeter](https://jmeter.apache.org/). Install it before running the tests.

## Run the tests

```bash
mkdir target
export JMETER_HOME=/data/apps/apache-jmeter-5.6.3/bin
rm -f target/results.jtl && rm -rf target/reports && $JMETER_HOME/jmeter -n -t src/main/resources/jmeter_test_plan.jmx -l target/results.jtl -e -o target/reports
```

## Current tests

JMeter test plan `jmeter_test_plan.jmx` currently evaluates the following scenarios:

* Search
  * Search using GeoNetwork search endpoint
  * Search using ElasticSearch search endpoint
  * CSW search

