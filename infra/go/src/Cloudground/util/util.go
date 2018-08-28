package util

import (
	"errors"
	"fmt"
	"github.com/fatih/color"
	"os"
	"os/exec"
	"syscall"
)

func Debug(format string, args ...interface{}) {
	color.Blue(format, args...)
}

func Info(format string, args ...interface{}) {
	color.White(format, args...)
}

func Step(format string, args ...interface{}) {
	color.Green(format, args...)
}

func Warning(format string, args ...interface{}) {
	color.Yellow(format, args...)
}

func Error(format string, args ...interface{}) {
	color.Red(format, args...)
}

func Fatal(err error, format string, args ...interface{}) {
	color.HiRed(format, args...)
	panic(err.Error())
}

func FatalError(format string, args ...interface{}) {
	message := fmt.Sprintf(format, args...)
	color.HiRed(message)
	panic(errors.New(message))
}

func ExitStatus(err error) (int, error) {
	if err != nil {
		if exiterr, ok := err.(*exec.ExitError); ok {
			// There is no platform independent way to retrieve
			// the exit code, but the following will work on Unix
			if status, ok := exiterr.Sys().(syscall.WaitStatus); ok {
				return int(status.ExitStatus()), nil
			}
		}
		return 0, err
	}
	return 0, nil
}

func DryRun(dryRun bool, action string, closure func()) {
	if !dryRun {
		closure()
	} else {
		Warning("DRY RUN: %s", action)
	}
}

func WriteFile(path, content string) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()
	_, err = file.WriteString(content)
	return err
}
