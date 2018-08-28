package cmd

import (
	"fmt"
	"os"

	"github.com/mitchellh/go-homedir"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	. "Cloudground/util"
)

var ProjectRoot string
var cfgFile string

var RootCmd = &cobra.Command{
	Use:   "cg",
	Short: "Cloudground command line utility",
	Long:  `This command line utility aims to make work with Cloudground easier`,
	//	Run: func(cmd *cobra.Command, args []string) { },
}

func Execute() {
	var err error
	if ProjectRoot, err = IdentifyRoot(); err != nil {
		Fatal(err, "Could not identify Cloudground root")
	}
	Debug("Using project root: %s", ProjectRoot)
	if err := RootCmd.Execute(); err != nil {
		Fatal(err, "Could not initialize Cloudground command line util")
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.
	RootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.cobra-example.yaml)")

	// Cobra also supports local flags, which will only run
	// when this action is called directly.
	RootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := homedir.Dir()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		// Search config in home directory with name ".cobra-example" (without extension).
		viper.AddConfigPath(home)
		viper.SetConfigName(".cobra-example")
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	}
}
