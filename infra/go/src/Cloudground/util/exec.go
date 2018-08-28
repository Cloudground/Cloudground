package util

import (
	"strings"
	"github.com/ionrock/procs"
)

type ExecOption func(*procs.Process) error

func Exec(cmd string, options ...ExecOption) (string, error) {
	process := procs.NewProcess(cmd)
	Info("Executing: %s", process.CmdString)

	for _, op := range options {
		err := op(process)
		if err != nil {
			return "", err
		}
	}

	process.Run()
	output, err := process.Output()
	if err != nil {
		Fatal(err, "Error during execution of: %s", process.CmdString)
	}
	return string(output), nil
}

func WithOutputHandler() ExecOption {
	return func(process *procs.Process) error {
		prefix := strings.Fields(process.CmdString)[0]
		process.OutputHandler = func(line string) string {
			Info("%s (std) | %s\n", prefix, line)
			return line
		}
		process.ErrHandler = func(line string) string {
			Info("%s (err) | %s\n", prefix, line)
			return line
		}
		return nil
	}
}
