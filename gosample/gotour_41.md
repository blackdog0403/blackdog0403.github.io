package main

import (
    "code.google.com/p/go-tour/wc"
    "strings"
)

func WordCount(s string) map[string]int {
    //func Fields(s string) []string

    countMap := make(map[string]int)
    p := strings.Fields(s)

    for _, value := range p {
    	countMap[value] = (countMap[value]+1)
	}

    return countMap
}

func main() {
    wc.Test(WordCount)
}
