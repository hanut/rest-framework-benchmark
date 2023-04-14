#ifndef Dtos_hpp
#define Dtos_hpp

#include "oatpp/core/macro/codegen.hpp"
#include "oatpp/core/Types.hpp"

#include OATPP_CODEGEN_BEGIN(DTO)

/**
 *  Login Request Dto
 */
class LoginReqDto : public oatpp::DTO
{

  DTO_INIT(LoginReqDto, DTO)

  DTO_FIELD(String, email);
  DTO_FIELD(String, password);
};

/**
 * LoginResponseDto
 */
class LoginResDto : public oatpp::DTO
{

  DTO_INIT(LoginResDto, DTO)

  DTO_FIELD(String, username);
  DTO_FIELD(String, role);
};

class ErrorDto : public oatpp::DTO
{
  DTO_INIT(ErrorDto, DTO)

  DTO_FIELD(Int16, statusCode);
  DTO_FIELD(String, statusText);
};

#include OATPP_CODEGEN_END(DTO)

#endif /* DTOs_hpp */