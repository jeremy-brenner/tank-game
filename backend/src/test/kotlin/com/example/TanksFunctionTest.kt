package com.example
import io.micronaut.gcp.function.http.*
import io.micronaut.http.*
import io.kotest.core.spec.style.StringSpec
import io.kotest.matchers.shouldBe

class TanksFunctionTest : StringSpec({

    "test function" {
       HttpFunction().use { function ->
           val response = function.invoke(HttpMethod.GET, "/tanks")
           response.status shouldBe HttpStatus.OK
        }
    }
})