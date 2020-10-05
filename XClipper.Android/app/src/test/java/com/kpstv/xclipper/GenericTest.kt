package com.kpstv.xclipper

import org.junit.Test
import kotlin.system.measureTimeMillis

class GenericTest {

    data class Person(private val name: String)

    @Test
    fun assertCheckClass() {
        val person1 = Person("John")
        val person2 = Person("Hannah")

        if (person1.javaClass == Person::class.java) {
            println("Classes are same")
        }else {
            println("Classes are different")
        }
    }

    @Test
    fun assertRegexMatchTest() {

        val seconds= measureTimeMillis {
            val regex = "^(!\\[)(.*?)(])(\\((https?://.*?)\\))$".toRegex()

            val text = "![Hello.png](https://google.com)"

            println(regex.matches(text))
        }
        println("Time took: $seconds")
    }
}