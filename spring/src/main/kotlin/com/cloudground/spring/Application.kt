package com.cloudground.spring

import org.springframework.boot.runApplication

// @SpringBootApplication
class Application {

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            runApplication<Application>(*args)
        }
    }

}

