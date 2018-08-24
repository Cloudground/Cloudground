package com.cloudground.spring

import lombok.Getter
import lombok.NoArgsConstructor
import lombok.Setter
import lombok.ToString
import org.springframework.data.annotation.Id

@Getter
@Setter
@NoArgsConstructor
@ToString
class Customer(var firstName: String, var lastName: String) {

    @Id
    var id: String? = null

}