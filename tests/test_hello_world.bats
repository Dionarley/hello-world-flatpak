#!/usr/bin/env bats

@test "hello-world headless print works" {
    run ./app/bin/hello-world --print
    [ "$status" -eq 0 ]
}
