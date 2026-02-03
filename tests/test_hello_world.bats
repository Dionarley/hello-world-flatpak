#!/usr/bin/env bats

@test "hello-world exits cleanly" {
    run ./app/bin/hello-world <<< ""
    [ "$status" -eq 0 ]
}
