package com.cloudground.spring

import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import org.assertj.core.api.Assertions.assertThat
import org.junit.Test

class JacksonKotlinTests {

    private val mapper = jacksonObjectMapper().configure(SerializationFeature.INDENT_OUTPUT, false)

    class StartsWithUppercase(@JsonProperty("name") val Name: String)

    class StartsWithUppercaseJava {
        @JsonProperty("name")
        lateinit var Name: String
    }

    @Test
    fun testStartsWithUppercaseJava_One_Constructor() {
        val expectedJson = """{"Name":"John Smith"}"""

        val expectedPerson = StartsWithUppercaseJava()
        expectedPerson.Name = "John Smith"

        val actualJson = ObjectMapper().writeValueAsString(expectedPerson)
        println(actualJson)
        val newPerson = ObjectMapper().readValue<StartsWithUppercaseJava>(actualJson)

        assertThat(actualJson).isEqualToIgnoringCase(expectedJson)
        assertThat(newPerson.Name).isEqualTo(expectedPerson.Name)
    }

    @Test
    fun testStartsWithUppercase_One_Constructor() {
        val expectedJson = """{"Name":"John Smith"}"""
        val expectedPerson = StartsWithUppercase("John Smith")

        val actualJson = mapper.writeValueAsString(expectedPerson)
        println(actualJson)
        val newPerson = mapper.readValue<StartsWithUppercase>(actualJson)

        assertThat(actualJson).isEqualToIgnoringCase(expectedJson)
        assertThat(newPerson.Name).isEqualTo(expectedPerson.Name)
    }

}
