package com.cloudground.spring

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/customers-rest")
class CustomersRestController {

    @Autowired
    lateinit var customerRepository: CustomerRepository

    @GetMapping
    fun getCustomers(): List<Customer> {
        return customerRepository.findAll()
    }

}