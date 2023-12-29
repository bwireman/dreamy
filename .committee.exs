defmodule Dreamy.Commit do
  use Committee
  import Committee.Helpers, only: [staged_files: 0, staged_files: 1]

  @impl true
  def pre_commit do
    results =
      [
        System.cmd("mix", ["hex.audit"]),
        System.cmd("mix", ["hex.outdated"]),
        System.cmd("mix", ["test"]),
        System.cmd("mix", ["format"] ++ staged_files([".ex", ".exs"])),
        System.cmd("mix", ["quality"]),
        System.cmd("git", ["add"] ++ staged_files())
      ]
      |> Enum.map(&format_cmd_results/1)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    if not Map.has_key?(results, :halt) do
      {:ok, Enum.join(results.ok, "\n")}
    else
      System.cmd("git", ["reset"])
      {:halt, Enum.join(results.halt, "\n")}
    end
  end

  defp format_cmd_results({msg, 0}), do: {:ok, msg}
  defp format_cmd_results({res, _}), do: {:halt, res}
end
