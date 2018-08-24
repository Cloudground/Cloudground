package com.cloudground.spring

import org.springframework.data.mongodb.repository.MongoRepository

interface CustomerRepository : MongoRepository<Customer, String> {

    fun findByFirstName(firstName: String): Customer

    fun findByLastName(lastName: String): List<Customer>

}