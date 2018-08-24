package com.cloudground.spring

import org.springframework.cloud.openfeign.FeignClient
import org.springframework.web.bind.annotation.GetMapping

data class StatusResponse(val status: String)

@FeignClient(value = "go", url = "192.168.99.100:30111")
interface GoStatusClient {

    // @RequestMapping(method = [RequestMethod.GET], value = ["/status"], consumes = ["application/json"])
    @GetMapping(value = ["/status"], consumes = ["application/json"])
    fun getStatus(): StatusResponse

    //    @RequestMapping(method = RequestMethod.POST, value = "/stores/{storeId}", consumes = "application/json")
    //    Store update(@PathVariable("storeId") Long storeId, Store store);

}