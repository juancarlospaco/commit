import os, osproc, rdstdin, strutils, random, times

const
  fakeCommitMessages = [
    "'Update documentation'", "'Fix a Typo'", "'Update README.md'", "'Optimization, minor'", "'Typo, minor'", "'Minor'", "'Fix README'",
    "'Update config'", "'Fix configuration'", "'Update configuration'", "'Fix trailing whitespaces'", "'Add Documentation'",
    "'Optimization of a structure'", "'Add a new line at the end of the file'", "'Remove extra spaces'", "'Code Style'", "'Updates'",
    "'Improve code style'", "'Fix wrong name on a variable'", "'Trim spaces'", "'Strip spaces'", "'Rename a variable'", "'Fixes'",
    "'-'", "'.'", "'Format code'", "'Reorder an import'", "'Minor, style'", "'Fix typo on documentation'", "'Optimizations'",
    "'Bump'", "'Fix Docs'", "'Add Docs'", "'Improve user documentation'", "'Minor optimizations'", "'Tiny refactor'", "'Working now'",
    "'init'", "'Add a test'", "'Fix a test'", "'improve a test'", "'tests'", "'Deprecate old stuff'", "'New code'", "'Small change'"]
  helpMsg = """What to do?
  0 --> Quit
  1 --> Commit several files 1 by 1 (git commit)
  2 --> Commit "Fake" empty commits (git commit --allow-empty)
  3 --> Undo Commits, back in time  (git reset --hard HEAD~N)
  Choose: """.unindent

template commit1by1() =
  let
    i = create(int, sizeOf int)
    mesgs = create(string, sizeOf string)
  mesgs[] = readLineFromStdin("Git Commit Message?: ").strip
  for file in readLineFromStdin("Files to Commit? (Whitespace separated): ").strip.splitWhitespace:
    echo execCmdEx("git commit --message='" & mesgs[] & "' --date='" & $(now() - minutes(i[])) & "' " & file.quoteShell).output
    inc i[]
  dealloc(i)
  dealloc(mesgs)

template commitFake() =
  once: randomize()
  for i in 0..readLineFromStdin("How many Fake Git Commits? (Integer): ").parseInt:
    echo execCmdEx("git commit --allow-empty --date='" & $(now() - minutes(i)) & "' --message=" & fakeCommitMessages.sample).output

template commitUndo() =
  if execCmdEx("git reset --hard HEAD~" & $readLineFromStdin("How many commits backwards to revert? (Integer): ").parseInt.Positive).exitCode == 0:
    echo execCmdEx("git commit --allow-empty --amend --message=" & readLineFromStdin("Git Commit Message?: ").strip).output

proc main() =
  case readLineFromStdin(helpMsg).parseInt
  of 0: quit("", 0)
  of 1: commit1by1()
  of 2: commitFake()
  of 3: commitUndo()
  else: quit("Wrong options")

when isMainModule: main()
