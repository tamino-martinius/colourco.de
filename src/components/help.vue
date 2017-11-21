<template>
  <div :class="$style.root">
    <h1><span>how it works</span><b>Help &amp;</b> Controls</h1>
    <table>
      <tr>
        <th>
          <h2>free build</h2>
        </th>
        <th>
          <h2>general</h2>
        </th>
        <th>
          <h2>schemes</h2>
        </th>
      </tr>
      <tr>
        <td>
          <table>
            <tr>
              <th>
                <div class="icon-plus"></div>
              </th>
              <td>
                add new swatch to scheme
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-trash"></div>
              </th>
              <td>
                remove swatch from scheme
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-left"></div>
              </th>
              <td>
                move one swatch to the left
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-right"></div>
              </th>
              <td>
                move one swatch to the right
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-up"></div>
              </th>
              <td>
                edit swatch or select another color type
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-marker"></div>
              </th>
              <td>
                marks current selected colors
              </td>
            </tr>
          </table>
        </td>
        <td>
          <table>
            <tr>
              <th>
                <div class="icon-mouse-h"></div>
              </th>
              <td>
                move mouse horizontal to change hue
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-mouse-v"></div>
              </th>
              <td>
                move mouse vertical to change lightness
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-mouse-s"></div>
              </th>
              <td>
                scroll mouse to change saturation
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-less"></div>
              </th>
              <td>
                save color / scheme as .less stylesheet
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-image"></div>
              </th>
              <td>
                save color / scheme as .png image
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-link"></div>
              </th>
              <td>
                opens permalink to color / scheme in new tab
              </td>
            </tr>
          </table>
        </td>
        <td>
          <table>
            <tr>
              <th>
                <div class="icon-plus"></div>
              </th>
              <td>
                increases number of swatches
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-minus"></div>
              </th>
              <td>
                decreases number of swatches
              </td>
            </tr>
            <tr>
              <th>
                <div class="icon-up"></div>
              </th>
              <td>
                change base color or select another color type
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</template>

<script lang="ts">
  export default {
  };
</script>

<style lang="stylus" module>
  .root {
    grid-area: content;
  }
</style>
