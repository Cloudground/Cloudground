package com.cloudground.spring

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/status")
class StatusRestController {

    @GetMapping
    fun getCustomers(): Any {
        return object {
            val Status: String = "OK"
        }
    }

}