#include <algorithm>
#include <bitset>
#include <fstream>
#include <iostream>
#include <string_view>
#include <vector>

constexpr auto file = "day03.in";

auto toMask(std::string_view s)
{
    std::bitset<64> mask;

    for (const auto &c : s)
    {
        if ('a' <= c && c <= 'z')
            mask[c - 'a' + 1] = 1;
        else
            mask[c - 'A' + 27] = 1;
    }

    return mask;
}

auto readInput(const std::string_view file)
{
    std::ifstream fin(file.data());
    std::vector<std::string> input;

    std::string line;
    while (std::getline(fin, line))
        input.emplace_back(line);

    return input;
}

auto part_1(const std::vector<std::string> &input)
{
    std::vector<std::pair<std::bitset<64>, std::bitset<64>>> inputAsMask(input.size());
    std::transform(input.cbegin(), input.cend(), inputAsMask.begin(), [](const std::string &s) {
        const auto n = s.size() / 2;
        return std::make_pair(toMask(s.substr(0, n)), toMask(s.substr(n)));
    });

    int ans = 0;
    for (const auto &[sackA, sackB] : inputAsMask)
    {
        for (int i = 1; i <= 52; ++i)
        {
            if (sackA[i] == 1 && sackB[i] == 1)
                ans += i;
        }
    }

    return ans;
}

auto part_2(const std::vector<std::string> &input)
{
    std::vector<std::bitset<64>> inputAsMask(input.size());
    std::transform(input.cbegin(), input.cend(), inputAsMask.begin(), [](const std::string &s) { return toMask(s); });

    int ans = 0;
    for (auto it = inputAsMask.cbegin(); it != inputAsMask.cend(); ++it)
    {
        const auto &sackA = *(it++), &sackB = *(it++), &sackC = *it;

        for (int i = 1; i <= 52; ++i)
        {
            if (sackA[i] == 1 && sackB[i] == 1 && sackC[i] == 1)
                ans += i;
        }
    }

    return ans;
}

auto main() -> int
{
    const auto input = readInput(file);
    std::cout << part_1(input) << '\n';
    std::cout << part_2(input) << '\n';
}
