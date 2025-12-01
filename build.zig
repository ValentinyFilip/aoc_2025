const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    inline for (1..12) |day| {
        const day_str = std.fmt.comptimePrint("day{d:0>2}", .{day});
        const path = std.fmt.comptimePrint("src/{s}.zig", .{day_str});

        // Create module for the day
        const day_module = b.createModule(.{
            .root_source_file = b.path(path),
            .target = target,
            .optimize = optimize,
        });

        // Executable for each day
        const exe = b.addExecutable(.{
            .name = day_str,
            .root_module = day_module,
        });
        b.installArtifact(exe);

        // Test for each day (all tests)
        const day_tests = b.addTest(.{
            .root_module = day_module,
        });

        const run_test = b.addRunArtifact(day_tests);

        const test_step = b.step(std.fmt.comptimePrint("test-{s}", .{day_str}), std.fmt.comptimePrint("Run tests for {s}", .{day_str}));
        test_step.dependOn(&run_test.step);

        // Example test only (short example)
        const example_tests = b.addTest(.{
            .root_module = day_module,
        });
        example_tests.filters = &.{"short example"};

        const run_example = b.addRunArtifact(example_tests);

        const example_step = b.step(std.fmt.comptimePrint("example-{s}", .{day_str}), std.fmt.comptimePrint("Run example tests for {s}", .{day_str}));
        example_step.dependOn(&run_example.step);
    }
}
