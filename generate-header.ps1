# Generate pixel-font SVG header for Game Boy theme
# 5x7 pixel font, each pixel = 4px, gap between chars = 4px

$font = @{
    'T' = @('11111','00100','00100','00100','00100','00100','00100')
    'E' = @('11111','10000','10000','11110','10000','10000','11111')
    'G' = @('01110','10001','10000','10011','10001','10001','01110')
    'U' = @('10001','10001','10001','10001','10001','10001','01110')
    'H' = @('10001','10001','10001','11111','10001','10001','10001')
    'J' = @('00111','00010','00010','00010','00010','10010','01100')
    'A' = @('01110','10001','10001','11111','10001','10001','10001')
    'N' = @('10001','11001','10101','10011','10001','10001','10001')
    'R' = @('11110','10001','10001','11110','10100','10010','10001')
    'I' = @('01110','00100','00100','00100','00100','00100','01110')
    'F' = @('11111','10000','10000','11110','10000','10000','10000')
    'L' = @('10000','10000','10000','10000','10000','10000','11111')
    'D' = @('11100','10010','10001','10001','10001','10010','11100')
    ' ' = @('000','000','000','000','000','000','000')
}

function Get-PixelText {
    param([string]$text, [int]$startX, [int]$startY, [int]$pixelSize, [string]$color)
    
    $rects = @()
    $curX = $startX
    $charGap = $pixelSize  # gap between characters
    
    foreach ($char in $text.ToCharArray()) {
        $key = [string]$char
        if (-not $font.ContainsKey($key)) { $key = ' ' }
        $rows = $font[$key]
        $charWidth = $rows[0].Length
        
        for ($row = 0; $row -lt $rows.Count; $row++) {
            for ($col = 0; $col -lt $rows[$row].Length; $col++) {
                if ($rows[$row][$col] -eq '1') {
                    $x = $curX + ($col * $pixelSize)
                    $y = $startY + ($row * $pixelSize)
                    $rects += "    <rect x=`"$x`" y=`"$y`" width=`"$pixelSize`" height=`"$pixelSize`"/>"
                }
            }
        }
        $curX += ($charWidth * $pixelSize) + $charGap
    }
    
    return "  <g fill=`"$color`">`n" + ($rects -join "`n") + "`n  </g>"
}

# Generate the full SVG
$pixelSize = 4
$nameY = 70
$name2Y = 108

$line1 = Get-PixelText -text "TEGUH JANUAR" -startX 234 -startY $nameY -pixelSize $pixelSize -color "#E6EDF3"
$line2 = Get-PixelText -text "RIFALDI" -startX 234 -startY $name2Y -pixelSize $pixelSize -color "#E6EDF3"

# Also generate "PLAYER 1" label smaller (3px pixels)
$playerLabel = Get-PixelText -text "PLAYER 1" -startX 234 -startY 46 -pixelSize 3 -color "#8BAC0F"

$svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 840 200" width="840" height="200">
  <!-- Background matching GitHub dark -->
  <rect width="840" height="200" fill="#0D1117"/>
  <rect x="2" y="2" width="836" height="196" rx="6" fill="none" stroke="#306230" stroke-width="1.5" opacity="0.6"/>

  <!-- Game Boy body -->
  <rect x="30" y="20" width="165" height="160" rx="14" fill="#C4CFA1" stroke="#A0A878" stroke-width="2"/>

  <!-- Screen bezel -->
  <rect x="44" y="32" width="136" height="100" rx="3" fill="#4B5320"/>
  <!-- Screen inner -->
  <rect x="50" y="38" width="124" height="88" rx="2" fill="#9BBC0F"/>

  <!-- Pixel art on screen: ghost -->
  <g fill="#306230">
    <rect x="82" y="46" width="8" height="8"/><rect x="90" y="46" width="8" height="8"/><rect x="98" y="46" width="8" height="8"/><rect x="106" y="46" width="8" height="8"/>
    <rect x="74" y="54" width="8" height="8"/><rect x="82" y="54" width="8" height="8"/><rect x="90" y="54" width="8" height="8"/><rect x="98" y="54" width="8" height="8"/><rect x="106" y="54" width="8" height="8"/><rect x="114" y="54" width="8" height="8"/>
    <rect x="74" y="62" width="8" height="8"/><rect x="82" y="62" width="8" height="8"/><rect x="98" y="62" width="8" height="8"/><rect x="106" y="62" width="8" height="8"/><rect x="114" y="62" width="8" height="8"/>
    <rect x="90" y="62" width="8" height="8" fill="#9BBC0F"/>
    <rect x="74" y="70" width="8" height="8"/><rect x="82" y="70" width="8" height="8"/><rect x="90" y="70" width="8" height="8"/><rect x="98" y="70" width="8" height="8"/><rect x="106" y="70" width="8" height="8"/><rect x="114" y="70" width="8" height="8"/>
    <rect x="74" y="78" width="8" height="8"/><rect x="82" y="78" width="8" height="8"/><rect x="90" y="78" width="8" height="8"/><rect x="98" y="78" width="8" height="8"/><rect x="106" y="78" width="8" height="8"/><rect x="114" y="78" width="8" height="8"/>
    <rect x="74" y="86" width="8" height="8"/><rect x="82" y="86" width="8" height="8"/><rect x="98" y="86" width="8" height="8"/><rect x="114" y="86" width="8" height="8"/>
  </g>
  <g fill="#0F380F">
    <rect x="82" y="62" width="4" height="8"/><rect x="106" y="62" width="4" height="8"/>
  </g>

  <!-- Score on screen -->
  <text x="60" y="110" font-family="monospace" font-size="8" fill="#306230" letter-spacing="1">SCORE 00239</text>
  <text x="114" y="110" font-family="monospace" font-size="8" fill="#306230" letter-spacing="1">LV.04</text>

  <!-- Power LED -->
  <circle cx="50" cy="140" r="3" fill="#8BAC0F"/>

  <!-- D-pad -->
  <rect x="54" y="142" width="8" height="24" rx="1" fill="#3D3D3D"/>
  <rect x="46" y="150" width="24" height="8" rx="1" fill="#3D3D3D"/>

  <!-- A B buttons -->
  <circle cx="150" cy="146" r="7" fill="#882255"/>
  <circle cx="168" cy="138" r="7" fill="#882255"/>
  <text x="150" y="149" font-family="monospace" font-size="6" fill="#DDAACC" text-anchor="middle" font-weight="bold">A</text>
  <text x="168" y="141" font-family="monospace" font-size="6" fill="#DDAACC" text-anchor="middle" font-weight="bold">B</text>

  <!-- Speaker grille -->
  <g stroke="#A0A878" stroke-width="1" opacity="0.5">
    <line x1="130" y1="162" x2="145" y2="172"/>
    <line x1="135" y1="162" x2="150" y2="172"/>
    <line x1="140" y1="162" x2="155" y2="172"/>
    <line x1="145" y1="162" x2="160" y2="172"/>
    <line x1="150" y1="162" x2="165" y2="172"/>
  </g>

  <!-- PLAYER 1 label (pixel font) -->
$playerLabel

  <!-- Name line 1 (pixel font) -->
$line1

  <!-- Name line 2 (pixel font) -->
$line2

  <!-- Subtitle (small, monospace is fine here) -->
  <text x="234" y="152" font-family="monospace" font-size="11" fill="#8B949E" letter-spacing="2">Web Dev // Front-End // 4 yrs</text>

  <!-- Blinking cursor -->
  <rect x="476" y="140" width="10" height="14" fill="#8BAC0F">
    <animate attributeName="opacity" values="1;0;1" dur="1.2s" repeatCount="indefinite"/>
  </rect>
</svg>
"@

$svg | Out-File -FilePath "assets\gameboy-header.svg" -Encoding utf8NoBOM
Write-Host "SVG generated successfully!"
Write-Host "File size: $((Get-Item 'assets\gameboy-header.svg').Length) bytes"
