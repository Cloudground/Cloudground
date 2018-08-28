package cmd

import (
	"github.com/spf13/cobra"
	"fmt"
	"github.com/skratchdot/open-golang/open"
	"strings"
	. "Cloudground/util"

	"flag"
	"path/filepath"
	"k8s.io/client-go/util/homedir"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/kubernetes"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"time"
)

var runCmd = &cobra.Command{
	Use:   "run",
	Short: "runs/stars/opens most used resources during development",
	Long:  `runs/stars/opens most used resources during development, use help to get list of possible arguments`,
}

var minikubeCpus int
var minikubeMemory int
var runMinikubeCmd = &cobra.Command{
	Use:   "minikube",
	Short: "run Minikube and prints useful urls",
	Run: func(cmd *cobra.Command, args []string) {
		_, _ = Exec("minikube status", WithOutputHandler())

		if minikubeStatus, _ := Exec("minikube status"); !strings.Contains(minikubeStatus, "Running") {
			Step("Starting Minikube")
			// execute(fmt.Sprintf("minikube --cpus %d --memory %d start", minikubeCpus, minikubeMemory))
		}
		minikubeDashboardUrl, _ := Exec("minikube dashboard --url")
		Step("Dashboard URL: %s", minikubeDashboardUrl)
		// open.Run(minikubeDashboardUrl)

		Step("Checking kubectl connectivity")
		getNodes()
	},
}

func getNodes() {
	var kubeconfig *string
	if home := homedir.HomeDir(); home != "" {
		kubeconfig = flag.String("kubeconfig", filepath.Join(home, ".kube", "config"), "(optional) absolute path to the kubeconfig file")
	} else {
		kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
	}
	flag.Parse()

	// use the current context in kubeconfig
	config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
	if err != nil {
		panic(err.Error())
	}

	// create the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}
	for {
		pods, err := clientset.CoreV1().Pods("").List(metav1.ListOptions{})
		if err != nil {
			panic(err.Error())
		}
		fmt.Printf("There are %d pods in the cluster\n", len(pods.Items))

		// Examples for error handling:
		// - Use helper functions like e.g. errors.IsNotFound()
		// - And/or cast to StatusError and use its properties like e.g. ErrStatus.Message
		namespace := "default"
		pod := "mongod-0"
		_, err = clientset.CoreV1().Pods(namespace).Get(pod, metav1.GetOptions{})
		if errors.IsNotFound(err) {
			fmt.Printf("Pod %s in namespace %s not found\n", pod, namespace)
		} else if statusError, isStatus := err.(*errors.StatusError); isStatus {
			fmt.Printf("Error getting pod %s in namespace %s: %v\n",
				pod, namespace, statusError.ErrStatus.Message)
		} else if err != nil {
			panic(err.Error())
		} else {
			fmt.Printf("Found pod %s in namespace %s\n", pod, namespace)
		}

		time.Sleep(5 * time.Second)
	}
}

func init() {
	RootCmd.AddCommand(runCmd)

	runCmd.AddCommand(runMinikubeCmd)
	runMinikubeCmd.Flags().IntVar(&minikubeCpus, "cpus", 2, "number of cpus for Minikube")
	runMinikubeCmd.Flags().IntVar(&minikubeMemory, "memory", 4096, "memory (in MB) for Minikube")

	runCmd.AddCommand(openUrl("slack", "opens Slack in default browser", "https://the-cloudground.slack.com"))
	runCmd.AddCommand(openUrl("github", "opens GitHub repository in default browser", "https://github.com/Cloudground/Cloudground"))
	runCmd.AddCommand(openUrl("ci", "opens CircleCI in default browser", "https://circleci.com/gh/Cloudground"))

	//commands := aliasCommands(*runGitHubCmd, []string{"repo", "repository"})
	//for _, command := range commands {
	//	Debug("Adding %s\n", command.Use)
	//	runCmd.AddCommand(&command)
	//}

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// runCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// runCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

func openUrl(use, short, url string) *cobra.Command {
	return &cobra.Command{
		Use:   use,
		Short: short,
		Run: func(cmd *cobra.Command, args []string) {
			open.Run(url)
		},
	}
}

func aliasCommands(command cobra.Command, aliases []string) []cobra.Command {
	commands := make([]cobra.Command, len(aliases))
	originalUse := command.Use
	for index, alias := range aliases {
		fmt.Printf("Aliasing %s as %s\n", originalUse, alias)
		commands[index] = *aliasCommand(command, alias)
		fmt.Printf("Result: %s\n", commands[index].Use)
	}
	return commands
}

func aliasCommand(command cobra.Command, alias string) *cobra.Command {
	command.Short = "see " + command.Use
	command.Long = "see " + command.Use
	command.Use = alias
	return &command
}
