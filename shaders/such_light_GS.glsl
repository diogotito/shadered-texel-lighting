#version 330

layout(triangles) in;
layout(triangle_strip, max_vertices=3) out;

in vec3 objPosition[];
in vec3 viewPosition[];
in vec3 objNormal[];
in vec2 objUV[];

out vec3 fObjPosition;
out vec3 fViewPosition;
out vec3 fObjNormal;
out vec2 fObjUV;

void main() {
	for (int i = 0; i < 3; i++) {
		fObjPosition = objPosition[i];
		fViewPosition = viewPosition[i];
		fObjNormal = objNormal[i];
		fObjUV = objUV[i];
		gl_Position = gl_in[i].gl_Position;
		EmitVertex();
	}
	EndPrimitive();
}