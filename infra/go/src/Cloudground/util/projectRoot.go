package util

import (
	"errors"
	"os"
	"path/filepath"
)

func IdentifyRoot() (string, error) {
	var (
		rootDir string
		err     error
		dir     string
	)
	if dir, err = os.Getwd(); err == nil {
		rootDir, err = identifyRoot(dir)
	}
	if err != nil {
		dir := filepath.Dir(os.Args[0])
		rootDir, err = identifyRoot(dir)
	}
	return rootDir, err
}

func identifyRoot(startDir string) (string, error) {
	dir, err := filepath.Abs(startDir)
	if err != nil {
		return "", err
	}
	root := string(os.PathSeparator)
	for dir != "." && dir != root {
		if isRoot(dir) {
			return dir, nil
		}
		dir = filepath.Dir(dir)
	}
	return "", errors.New("could not find root directory")
}

func isRoot(dir string) bool {
	_, err := os.Stat(filepath.Join(dir, "cg.sh"))
	return !os.IsNotExist(err)
}
