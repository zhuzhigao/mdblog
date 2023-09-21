package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	directory := "." // 替换为你要处理的目录路径
	err := filepath.Walk(directory, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if !info.IsDir() && strings.HasSuffix(info.Name(), ".md") {
			content, err := ioutil.ReadFile(path)
			if err != nil {
				return err
			}

			lines := strings.Split(string(content), "\n")
			var title string
			var date string
			for i, line := range lines {
				if strings.Contains(line, "title:") {
					title = strings.TrimSpace(strings.Split(line, "title:")[1])
				}
				if strings.Contains(line, "date:") {
					date = strings.TrimSpace(strings.Split(line, "date:")[1])
				}
				if strings.Contains(line, "-->") {
					lines = append(lines[:i+1], append([]string{"Date: " + date}, lines[i+1:]...)...)
					lines = append(lines[:i+1], append([]string{"### " + title}, lines[i+1:]...)...)
					break
				}
			}

			newContent := strings.Join(lines, "\n")
			err = ioutil.WriteFile(path, []byte(newContent), 0644)
			if err != nil {
				return err
			}
		}
		return nil
	})

	if err != nil {
		fmt.Println("Error:", err)
	}
}
