#!/bin/bash

@test "returns days from then to now" {
  num=10
  futureDate=$(date -d "-${num} days")
  difference=$(datediff "$futureDate")
  [ "$difference" -eq "$num" ]
}
