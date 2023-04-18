#ifndef Controller_hpp
#define Controller_hpp

#include <ctime>
#include <iostream>
#include "Dtos.hpp"
#include "oatpp/web/server/api/ApiController.hpp"
#include "oatpp/core/macro/codegen.hpp"
#include "oatpp/core/macro/component.hpp"

#include OATPP_CODEGEN_BEGIN(ApiController) //<-- Begin Codegen

/**
 * Sample Api Controller.
 */
class Controller : public oatpp::web::server::api::ApiController {
public:
  /**
   * Constructor with object mapper.
   * @param objectMapper - default object mapper used to serialize/deserialize DTOs.
   */
  Controller(OATPP_COMPONENT(std::shared_ptr<ObjectMapper>, objectMapper))
    : oatpp::web::server::api::ApiController(objectMapper)
  {}

public:
  ENDPOINT("POST", "/", login, BODY_DTO(Object<LoginReqDto>, loginDto)) {
    std::time_t result = std::time(nullptr);
    std::cout << std::asctime(std::localtime(&result)) << " POST / \n";
    if (loginDto->email != "hanutsingh@gmail.com" || loginDto->password != "qweasd@123") {
      auto errDto = ErrorDto::createShared();
      errDto->statusCode = 401;
      errDto->statusText = "Unauthorized";
      return createDtoResponse(Status::CODE_401, errDto);
    }
    auto data = LoginResDto::createShared();
    data->username = "hanut";
    data->role = "super admin";
    return createDtoResponse(Status::CODE_200, data);
  }
  
};

#include OATPP_CODEGEN_END(ApiController) //<-- End Codegen

#endif /* Controller_hpp */