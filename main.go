package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func main() {
	fmt.Println("Starting server")
	http.HandleFunc("/", func(rw http.ResponseWriter, req *http.Request) {
		urls, found := req.URL.Query()["url"]
		if !found || len(urls) < 1 {
			urls = []string{"https://google.com"}
		}
		response, err := http.Get(urls[0])
		if err != nil {
			fmt.Println(fmt.Errorf("An error occured: %s", err))
			rw.WriteHeader(http.StatusInternalServerError)
			rw.Write([]byte("500 - Something bad happened!"))
			return
		}
		defer response.Body.Close()
		body, err := ioutil.ReadAll(response.Body)
		rw.WriteHeader(http.StatusOK)
		rw.Write(body)
	})
	http.ListenAndServe(":8080", nil)
}
