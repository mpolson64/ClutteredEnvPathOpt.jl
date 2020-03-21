using ClutteredEnvPathOpt
using Plots

function gen_separator_size(func, generator, range)
    return map(
        i -> begin
            lg = LabeledGraph(generator(i))
            (separator, a, b) = func(lg, 1)
            return length(separator)
        end,
        range
    )
end

function gen_balance(func, generator, range)
    return map(
        i -> begin
            lg = LabeledGraph(generator(i))
            (separator, a, b) = func(lg, 1)
            return length(a) / length(b)
        end,
        range
    )
end

function gen_elapsed(func, generator, range)
    return map(
        i -> begin
            lg = LabeledGraph(generator(i))
            return @elapsed func(lg, 1)
        end,
        range
    )
end

function compare(metric, generator, range, filename)
    data = hcat(
        metric(find_separator_lt, generator, range),    
        metric(find_separator_fcs, generator, range),
        metric(find_separator_fcs_best, generator, range),
    )

    plot(range, data, title = filename, label = ["Lipton-Tarjan" "FCS" "FCS Best"])
    savefig(string("stats/", filename, ".png"))
end

compare(gen_balance, i -> ClutteredEnvPathOpt.LightGraphs.grid([i, i]), (3:20), "time")