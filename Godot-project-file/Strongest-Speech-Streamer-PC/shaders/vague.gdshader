shader_type canvas_item;

uniform float lod: hint_range(0.0, 5) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 center = vec2(0.5, 0.5);  // 中心点坐标（归一化）
uniform vec2 size = vec2(1, 1);

void fragment() {
    // 计算当前像素是否在中间区域
    vec2 uv = SCREEN_UV;
    bool is_inside = (uv.x > center.x - size.x / 2.0) && (uv.x < center.x + size.x / 2.0) &&
                     (uv.y > center.y - size.y / 2.0) && (uv.y < center.y + size.y / 2.0);

    // 采样颜色
    vec4 color = texture(SCREEN_TEXTURE, uv, is_inside ? 0.0 : lod);

    // 输出颜色
    COLOR = color;
}