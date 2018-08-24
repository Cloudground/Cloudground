package com.cloudground.spring

//@Configuration
//@EnableMongoRepositories("com.cloudground.spring")
//class SpringMongoConfig : AbstractMongoConfiguration() {
//
//    public override fun getDatabaseName(): String {
//        return "cloudground-spring"
//    }
//
//    @Bean
//    override fun mongoClient(): MongoClient {
//        return MongoClient(getServers(),
//                // return MongoClient(ServerAddress("mongod-1.mongodb-service.default.192.168.99.102.nip.io"),
//                MongoCredential.createCredential("cloudground", "admin", "cloudground".toCharArray()),
//                MongoClientOptions.Builder().build())
//    }
//
//    fun getServers(): List<ServerAddress> {
//        return listOf(ServerAddress("192.168.99.102", 30010),
//                ServerAddress("192.168.99.102", 30011),
//                ServerAddress("192.168.99.102", 30012))
//    }
//
//}