#version 330

#ifndef TRIANGLE_SIZE
#define TRIANGLE_SIZE 0.02
#endif

layout(triangles) in;
layout(triangle_strip, max_vertices=12) out;

in vec3 objPosition[];
in vec3 viewPosition[];
in vec3 objNormal[];
in vec2 objUV[];

out float fIsDebug;
out vec3 fObjPosition;
out vec3 fViewPosition;
out vec3 fObjNormal;
out vec2 fObjUV;

void main() {
	// Pass through vertices as if this Geometry Shader wasn't here
	fIsDebug = 0.0;
	for (int i = 0; i < 3; i++) {
		fObjPosition = objPosition[i];
		fViewPosition = viewPosition[i];
		fObjNormal = objNormal[i];
		fObjUV = objUV[i];
		gl_Position = gl_in[i].gl_Position;
		EmitVertex();
	}
	EndPrimitive();

	// Add sneaky little arrows
	fIsDebug = 1.0;
	for (int i = 0; i < 3; i++) {
		fObjPosition = objPosition[i];
		fViewPosition = viewPosition[i];
		fObjNormal = objNormal[i];
		fObjUV = objUV[i];
		gl_Position = gl_in[i].gl_Position + vec4(-TRIANGLE_SIZE, -TRIANGLE_SIZE, 0.0, 0.0);
		EmitVertex();
		gl_Position = gl_in[i].gl_Position + vec4(TRIANGLE_SIZE , -TRIANGLE_SIZE, 0.0, 0.0);
		EmitVertex();
		gl_Position = gl_in[i].gl_Position + vec4(0.0           ,  TRIANGLE_SIZE, 0.0, 0.0);
		EmitVertex();
		EndPrimitive();
	}
}