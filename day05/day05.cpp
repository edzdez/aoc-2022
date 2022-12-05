#include <algorithm>
#include <fstream>
#include <iostream>
#include <ranges>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

constexpr auto file = "day05.in";

struct Instruction
{
    size_t n, u, v;

    Instruction(size_t n, size_t u, size_t v)
        : n(n)
        , u(u)
        , v(v)
    {
    }
};

using Input = std::pair<std::vector<std::vector<char>>, std::vector<Instruction>>;

auto readInput(std::string_view file) -> Input
{
    std::ifstream fin(file.data());

    std::vector<std::vector<char>> locations(10);
    std::vector<Instruction> instructions;

    std::string line;
    while (std::getline(fin, line))
    {
        if (line.empty())
            break;
        if (line[1] == '1')
            continue;

        std::string_view line_view(line);
        for (size_t i = 1; i <= 10; ++i)
        {
            const auto idx = (i - 1) * 4 + 1;
            if (idx >= line.size())
                continue;

            const auto c = line[idx];
            if (c != ' ')
                locations[i].push_back(c);
        }
    }

    for (auto &vec : locations)
        std::reverse(vec.begin(), vec.end());

    while (std::getline(fin, line))
    {
        std::istringstream ss(line);
        std::string n, u, v, temp;
        ss >> temp >> n >> temp >> u >> temp >> v;

        instructions.emplace_back(std::stoi(n), std::stoi(u), std::stoi(v));
    }

    return std::make_pair(locations, instructions);
}

auto day_1(Input input) -> std::string
{
    auto &[locations, instructions] = input;

    std::string ans;
    for (auto [n, u, v] : instructions)
    {
        while (n--)
        {
            const auto c = *locations[u].crbegin();
            locations[u].pop_back();
            locations[v].push_back(c);
        }
    }

    for (const auto &pile : locations)
    {
        if (pile.empty())
            continue;

        const auto c = *pile.crbegin();
        ans += c;
    }

    return ans;
}

auto day_2(Input input) -> std::string
{
    auto &[locations, instructions] = input;

    std::string ans;
    for (auto [n, u, v] : instructions)
    {
        for (auto it = locations[u].end() - n; it != locations[u].end(); ++it)
            locations[v].push_back(*it);

        for (size_t i = 0; i < n; ++i)
            locations[u].pop_back();
    }

    for (const auto &pile : locations)
    {
        if (pile.empty())
            continue;

        const auto c = *pile.crbegin();
        ans += c;
    }

    return ans;
}

auto main() -> int
{
    auto input = readInput(file);
    std::cout << day_1(input) << '\n';
    std::cout << day_2(input) << '\n';
}
