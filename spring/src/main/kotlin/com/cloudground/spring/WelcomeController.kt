package com.cloudground.spring

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.beans.factory.annotation.Autowired



@Controller
class WelcomeController {

    @Autowired
    lateinit var goStatusClient: GoStatusClient

    @RequestMapping("/ui")
    fun welcome(model: MutableMap<String, Any>): String {
        model["message"] = goStatusClient.getStatus().status
        return "welcome"
    }

}