using FixedLengthStrings
using Base.Test

test_string = "foo"

test_tiny = @tiny_string "foo"
test_short = @short_string "foo"
test_mid = @mid_string "foo"

@test test_tiny == test_string
@test test_tiny == test_short
@test test_tiny == test_mid

tiny_length = 4
short_length = 16
mid_length = 64

@test length(test_tiny.sv) == tiny_length
@test length(test_short.sv) == short_length
@test length(test_mid.sv) == mid_length

@test_throws ErrorException try @eval @tiny_string("foobar") catch err; throw(err.error) end
