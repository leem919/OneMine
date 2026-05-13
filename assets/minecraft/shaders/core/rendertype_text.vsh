#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

bool textColour_ingui(mat4 projectionMat) {
	return projectionMat[2][3] == 0.0;
}
int textColour_toint(vec3 col) {
  ivec3 icol = ivec3(col*255);
  return (icol.r << 16) + (icol.g << 8) + icol.b;
}
vec3 textColour_tovec(int col) {
	return vec3(col >> 16, (col >> 8) % 256, col % 256) / 255.;
}

vec4 textColour_recolourText(vec4 colourAttribute, mat4 projectionMatrix) {
	if(!textColour_ingui(projectionMatrix)) return colourAttribute;

	switch(textColour_toint(colourAttribute.rgb)) {
		// New Recipes unlocked
		case 0x500050:
		return vec4(textColour_tovec(0xffde29), colourAttribute.a);
		// Check your recipe book
		case 0x000000:
		return vec4(textColour_tovec(0xffffff), colourAttribute.a);
		// XP Text
		case 0x80ff20:
		return vec4(textColour_tovec(0x1ccf51), colourAttribute.a);
		// XP Text Shadow
		case 0x203f08:
		return vec4(textColour_tovec(0x001606), colourAttribute.a);
	}

	return colourAttribute;
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = textColour_recolourText(Color, ProjMat) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
}