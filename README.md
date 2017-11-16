# FixedLengthStrings

[![Build Status](https://travis-ci.org/djsegal/FixedLengthStrings.jl.svg?branch=master)](https://travis-ci.org/djsegal/FixedLengthStrings.jl)

[![codecov.io](http://codecov.io/github/djsegal/FixedLengthStrings.jl/coverage.svg?branch=master)](http://codecov.io/github/djsegal/FixedLengthStrings.jl?branch=master)

# Docs

Extracted from tests:

``` julia
test_string = "foo"

test_tiny = @tiny_string "foo"
test_short = @short_string "foo"
test_mid = @mid_string "foo"
# test_long = @long_string "foo"
# test_text = @text_string "foo"

@test test_tiny == test_string
@test test_tiny == test_short
@test test_tiny == test_mid

tiny_length = 4
short_length = 16
mid_length = 64
# long_length = 256
# text_length = 1024

@test length(test_tiny.sv) == tiny_length
@test length(test_short.sv) == short_length
@test length(test_mid.sv) == mid_length

# note: the following would throw a size error:
#   @tiny_string "foobar"

```
