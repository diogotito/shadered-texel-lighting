#version 330

uniform mat4 matVP;
uniform mat4 matGeo;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 tangent;
layout (location = 3) in vec3 bitangent;
layout (location = 4) in vec2 texcoord;

out vec3 objPosition;
out vec3 objNormal;
out vec2 objUV;
out mat3 tbn;

void main() {
   objNormal = (matGeo * vec4(normal, 0)).xyz;
   objPosition = (matGeo * vec4(pos, 1)).xyz;
   objUV = texcoord;
   tbn = mat3(tangent, bitangent, normal);
   gl_Position = matVP * matGeo * vec4(pos, 1);
}
