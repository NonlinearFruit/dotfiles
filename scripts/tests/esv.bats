#!/bin/bash

@test "gets Genisis 1:1" {
  esv gen 1:1 | grep "In the beginning, God created the heavens and the earth"
}
