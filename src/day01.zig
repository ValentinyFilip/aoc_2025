const std = @import("std");
const fetcher = @import("util/fetcher.zig");

pub fn part1(input: []const u8, debug: bool) !i64 {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var result: i64 = 0;
    var dial: i64 = 50;

    if (debug) std.debug.print("\n=== Starting part1 ===\n", .{});
    if (debug) std.debug.print("Initial dial: {d}\n", .{dial});

    while (lines.next()) |line| {
        const direction = line[0];
        const times = try std.fmt.parseInt(i64, line[1..], 10);

        if (debug) std.debug.print("\nDirection: {c}, Times: {d}\n", .{ direction, times });
        if (debug) std.debug.print("Dial before: {d}\n", .{dial});

        switch (direction) {
            'L' => {
                dial -= times;
                if (debug) std.debug.print("After L: dial = {d}\n", .{dial});

                if (dial == 0) {
                    result += 1;
                    if (debug) std.debug.print("Hit 0! Result: {d}\n", .{result});
                } else if (dial < 0) {
                    dial = @mod(dial, 100);
                    if (debug) std.debug.print("Wrapped around: new dial={d}\n", .{dial});
                    if (dial == 0) {
                        result += 1;
                        if (debug) std.debug.print("Hit 0! Result: {d}\n", .{result});
                    }
                }
            },
            'R' => {
                dial += times;
                if (debug) std.debug.print("After R: dial = {d}\n", .{dial});

                if (dial == 0) {
                    result += 1;
                    if (debug) std.debug.print("Hit 0! Result: {d}\n", .{result});
                } else if (dial > 99) {
                    dial = @mod(dial, 100);
                    if (debug) std.debug.print("Wrapped around: new dial={d}\n", .{dial});
                    if (dial == 0) {
                        result += 1;
                        if (debug) std.debug.print("Hit 0! Result: {d}\n", .{result});
                    }
                }
            },
            else => {},
        }

        if (debug) std.debug.print("Dial after: {d}, Result: {d}\n", .{ dial, result });
    }

    if (debug) std.debug.print("\n=== Final result: {d} ===\n\n", .{result});
    return result;
}

pub fn part2(input: []const u8, debug: bool) !i64 {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var result: i64 = 0;
    var dial: i64 = 50;

    if (debug) std.debug.print("\n=== Starting part1 ===\n", .{});
    if (debug) std.debug.print("Initial dial: {d}\n", .{dial});

    while (lines.next()) |line| {
        const direction = line[0];
        const times = try std.fmt.parseInt(i64, line[1..], 10);

        if (debug) std.debug.print("\nDirection: {c}, Times: {d}\n", .{ direction, times });
        if (debug) std.debug.print("Dial before: {d}\n", .{dial});

        switch (direction) {
            'L' => {
                const start_dial = dial;
                dial -= times;
                if (debug) std.debug.print("After L: dial = {d}\n", .{dial});

                if (dial < 0) {
                    const tempRes = if (start_dial == 0)
                        @divFloor(-dial - 1, 100) // Don't count starting position
                    else
                        @divFloor(-dial, 100) + 1; // Count the crossing

                    result += tempRes;
                    if (debug) std.debug.print("Hit 0! Result: {d} TempRes: {d}\n", .{ result, tempRes });
                    dial = @mod(dial, 100);
                    if (debug) std.debug.print("Wrapped around: new dial={d}\n", .{dial});
                } else if (dial == 0) {
                    result += 1;
                    if (debug) std.debug.print("Landed on 0! Result: {d}\n", .{result});
                }
            },
            'R' => {
                dial += times;
                if (debug) std.debug.print("After R: dial = {d}\n", .{dial});

                if (dial > 99) {
                    const tempRes = @divFloor(dial, 100);
                    result += tempRes;
                    if (debug) std.debug.print("Hit 0! Result: {d} TempRes: {d}\n", .{ result, tempRes });
                    dial = @mod(dial, 100);
                    if (debug) std.debug.print("Wrapped around: new dial={d}\n", .{dial});
                }
            },
            else => {},
        }

        if (debug) std.debug.print("Dial after: {d}, Result: {d}\n", .{ dial, result });
    }

    if (debug) std.debug.print("\n=== Final result: {d} ===\n\n", .{result});
    return result;
}

test "day01 part1 - short example" {
    const test_input =
        \\L668
        \\L30
        \\R48
        \\L5
        \\R460
        \\L55
        \\L1
        \\L99
        \\R14
        \\L382
    ;
    try std.testing.expectEqual(@as(i64, 6), try part2(test_input, true)); // Debug ON
}

test "day01 part1 - full input" {
    const allocator = std.testing.allocator;
    const input = try fetcher.getInput(allocator, 1);
    defer allocator.free(input);

    try std.testing.expectEqual(@as(i64, 1145), try part1(input, false)); // Debug OFF
}

test "day01 part2 - full input" {
    const allocator = std.testing.allocator;
    const input = try fetcher.getInput(allocator, 1);
    defer allocator.free(input);

    try std.testing.expectEqual(@as(i64, 12345), try part2(input, true));
}
