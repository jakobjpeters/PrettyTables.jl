# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#    Tests of offset arrays.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@testset "Default printing" begin
    expected = """
┌─────────┬─────────┬────────┬────────┐
│ Col. -2 │ Col. -1 │ Col. 0 │ Col. 1 │
├─────────┼─────────┼────────┼────────┤
│       1 │   false │    1.0 │      1 │
│       2 │    true │    2.0 │      2 │
│       3 │   false │    3.0 │      3 │
│       4 │    true │    4.0 │      4 │
│       5 │   false │    5.0 │      5 │
│       6 │    true │    6.0 │      6 │
└─────────┴─────────┴────────┴────────┘
"""

    result = pretty_table(String, odata)
    @test result == expected

    expected = """
┌───┬───────┬─────┬───┐
│ 1 │     2 │   3 │ 4 │
├───┼───────┼─────┼───┤
│ 1 │ false │ 1.0 │ 1 │
│ 2 │  true │ 2.0 │ 2 │
│ 3 │ false │ 3.0 │ 3 │
│ 4 │  true │ 4.0 │ 4 │
│ 5 │ false │ 5.0 │ 5 │
│ 6 │  true │ 6.0 │ 6 │
└───┴───────┴─────┴───┘
"""

    result = pretty_table(String, odata; header = 1:1:4)
    @test result == expected

    result = pretty_table(String, odata; header = OffsetArray(1:1:4, -5:-2))
    @test result == expected
end

@testset "Formatters" begin
    ft_row = (v, i, j) -> (i == -3) ? 0 : v

    expected = """
┌─────────┬─────────┬────────┬────────┐
│ Col. -2 │ Col. -1 │ Col. 0 │ Col. 1 │
├─────────┼─────────┼────────┼────────┤
│       1 │     0.0 │    1.0 │      1 │
│       0 │       0 │      0 │      0 │
│       3 │     0.0 │    3.0 │      3 │
│       4 │     1.0 │    4.0 │      4 │
│       5 │     0.0 │    5.0 │      5 │
│       6 │     1.0 │    6.0 │      6 │
└─────────┴─────────┴────────┴────────┘
"""

    result = pretty_table(String, odata; formatters = (ft_round(2, [-1]), ft_row))
    @test result == expected
end

@testset "Highlighters" begin

    expected = """
┌─────────┬─────────┬────────┬────────┐
│\e[1m Col. -2 \e[0m│\e[1m Col. -1 \e[0m│\e[1m Col. 0 \e[0m│\e[1m Col. 1 \e[0m│
├─────────┼─────────┼────────┼────────┤
│       1 │   false │    1.0 │\e[33;1m      1 \e[0m│
│       2 │    true │    2.0 │\e[33;1m      2 \e[0m│
│       3 │   false │    3.0 │\e[33;1m      3 \e[0m│
│\e[33;1m       4 \e[0m│\e[33;1m    true \e[0m│\e[33;1m    4.0 \e[0m│\e[33;1m      4 \e[0m│
│       5 │   false │    5.0 │\e[33;1m      5 \e[0m│
│       6 │    true │    6.0 │\e[33;1m      6 \e[0m│
└─────────┴─────────┴────────┴────────┘
"""

    c = crayon"yellow bold"
    result = sprint(
        (io)->pretty_table(io, odata; highlighters = (hl_row(-1, c), hl_col(1, c))),
        context = :color => true
    )
end

@testset "Row labels" begin
    expected = """
┌───────┬─────────┬─────────┬────────┬────────┐
│ Label │ Col. -2 │ Col. -1 │ Col. 0 │ Col. 1 │
├───────┼─────────┼─────────┼────────┼────────┤
│     1 │       1 │   false │    1.0 │      1 │
│     3 │       2 │    true │    2.0 │      2 │
│     5 │       3 │   false │    3.0 │      3 │
│     7 │       4 │    true │    4.0 │      4 │
│     9 │       5 │   false │    5.0 │      5 │
│    11 │       6 │    true │    6.0 │      6 │
└───────┴─────────┴─────────┴────────┴────────┘
"""

    result = pretty_table(
        String,
        odata;
        row_labels = 1:2:12,
        row_label_column_title = "Label"
    )
    @test result == expected

    result = pretty_table(
        String,
        odata;
        row_labels = OffsetArray(1:2:12, -5:0),
        row_label_column_title = "Label"
    )
    @test result == expected
end

@testset "Row numbers" begin
    expected = """
┌─────┬─────────┬─────────┬────────┬────────┐
│ Row │ Col. -2 │ Col. -1 │ Col. 0 │ Col. 1 │
├─────┼─────────┼─────────┼────────┼────────┤
│  -4 │       1 │   false │    1.0 │      1 │
│  -3 │       2 │    true │    2.0 │      2 │
│  -2 │       3 │   false │    3.0 │      3 │
│  -1 │       4 │    true │    4.0 │      4 │
│   0 │       5 │   false │    5.0 │      5 │
│   1 │       6 │    true │    6.0 │      6 │
└─────┴─────────┴─────────┴────────┴────────┘
"""

    result = pretty_table(String, odata; show_row_number = true)
    @test result == expected
end
