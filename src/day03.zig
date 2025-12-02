const std = @import("std");
const fetcher = @import("util/fetcher.zig");

pub fn part1(input: []const u8, debug: bool) !u64 {
    _ = input;
    _ = debug;
    return 5;
}

pub fn part2(input: []const u8, debug: bool) !u64 {
    _ = input;
    _ = debug;
    return 5;
}

test "day03 part1 - short example" {
    const test_input =
        \\
    ;
    try std.testing.expectEqual(@as(u64, 4174379265), try part1(test_input, true));
}

test "day03 part1 - full input" {
    const allocator = std.testing.allocator;
    const input = try fetcher.getInput(allocator, 3);
    defer allocator.free(input);

    try std.testing.expectEqual(@as(u64, 12345), try part1(input, false));
}

test "day03 part2 - full input" {
    const allocator = std.testing.allocator;
    const input = try fetcher.getInput(allocator, 3);
    defer allocator.free(input);

    try std.testing.expectEqual(@as(u64, 12345), try part2(input, false));
}
