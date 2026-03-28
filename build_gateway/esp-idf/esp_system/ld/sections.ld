/* Automatically generated file; DO NOT EDIT */
/* Espressif IoT Development Framework Linker Script */
/* Generated from: /Users/tn/batear/build_gateway/esp-idf/esp_system/ld/sections.ld.in */

/*
 * SPDX-FileCopyrightText: 2021 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/*
 * SPDX-FileCopyrightText: 2021-2024 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/*
 * Automatically generated file. DO NOT EDIT.
 * Espressif IoT Development Framework (ESP-IDF) 6.1.0 Configuration Header
 */
       
/* List of deprecated options */
/* CPU instruction prefetch padding size for flash mmap scenario */
/* Copy from esp_secure_boot.h */
/*
 * PMP region granularity size
 * Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones
 * to pmpaddr0, then reading back pmpaddr0. If G is the index of the least-significant bit set,
 * the PMP granularity is 2^G+2 bytes.
 */
/* CPU instruction prefetch padding size for memory protection scenario */
/* Memory alignment size for PMS */
    /* rtc timer data (s_rtc_timer_retain_mem, see esp_clk.c files). For rtc_timer_data_in_rtc_mem section. */
/*
 * FAST_REFLASHING_PADDING
 *
 * Aligns the current location (.) to CONFIG_ESPTOOLPY_FAST_REFLASHING_PADDING.
 * If more than half of the alignment block is already consumed,
 * extra padding is applied to skip to the next boundary.
 * For example, if the current location (.) is 0x1900 and the padding is 4 KB,
 * the location will be moved to 0x3000 instead of 0x2000 because less than
 * half of the current 4 KB block remains (0x2000 - 0x1900 < 2 KB).
 */
/* Default entry point */
ENTRY(call_start_cpu0);
SECTIONS
{
  /**
   * RTC fast memory holds RTC wake stub code,
   * including from any source file named rtc_wake_stub*.c
   */
  .rtc.text :
  {
    
 . = ALIGN(4); 
 _rtc_fast_start = ABSOLUTE(.);
    
 . = ALIGN(4); 
 _rtc_text_start = ABSOLUTE(.);
    HIDDEN(_rtc_code_start = .);
    *(.rtc.entry.literal .rtc.entry.text)
    
 *(.rtc.literal .rtc.text .rtc.text.*)
    *rtc_wake_stub*.*(.literal .text .literal.* .text.*)
    *(.rtc_text_end_test)
    HIDDEN(_rtc_code_end = .);
    /* Padding for possible CPU prefetch + 4B alignment for PMS split lines. */
    . = ((_rtc_code_end - _rtc_code_start) == 0) ?
        ALIGN(0) : 16 + ALIGN(4);
    _rtc_text_end = ABSOLUTE(.);
  } > rtc_iram_seg
  /**
   * This section located in RTC FAST Memory area.
   * It holds data marked with RTC_FAST_ATTR attribute.
   * See the file "esp_attr.h" for more information.
   */
  .rtc.force_fast :
  {
    
 . = ALIGN(4); 
 _rtc_force_fast_start = ABSOLUTE(.);
    
    *(.rtc.force_fast .rtc.force_fast.*)
    
 . = ALIGN(4); 
 _rtc_force_fast_end = ABSOLUTE(.);
  } > rtc_data_seg
  /**
   * RTC data section holds RTC wake stub
   * data/rodata, including from any source file
   * named rtc_wake_stub*.c and the data marked with
   * RTC_DATA_ATTR, RTC_RODATA_ATTR attributes.
   * The memory location of the data is dependent on
   * CONFIG_ESP32S3_RTCDATA_IN_FAST_MEM option.
   */
  .rtc.data :
  {
    _rtc_data_start = ABSOLUTE(.);
    
 *(.rtc.data .rtc.data.*)
 *(.rtc.rodata .rtc.rodata.*)
    *rtc_wake_stub*.*(.data .rodata .data.* .rodata.*)
    _rtc_data_end = ABSOLUTE(.);
  } > rtc_data_location
  /* RTC bss, from any source file named rtc_wake_stub*.c */
  .rtc.bss (NOLOAD) :
  {
    _rtc_bss_start = ABSOLUTE(.);
    *rtc_wake_stub*.*(.bss .bss.*)
    *rtc_wake_stub*.*(COMMON)
    
 *(.rtc.bss)
    _rtc_bss_end = ABSOLUTE(.);
  } > rtc_data_location
  /**
   * This section holds data that should not be initialized at power up
   * and will be retained during deep sleep.
   * User data marked with RTC_NOINIT_ATTR will be placed
   * into this section. See the file "esp_attr.h" for more information.
   * The memory location of the data is dependent on
   * CONFIG_ESP32S3_RTCDATA_IN_FAST_MEM option.
   */
  .rtc_noinit (NOLOAD):
  {
    
 . = ALIGN(4); 
 _rtc_noinit_start = ABSOLUTE(.);
    
    *(.rtc_noinit .rtc_noinit.*)
    
 . = ALIGN(4); 
 _rtc_noinit_end = ABSOLUTE(.);
  } > rtc_data_location
  /**
   * This section located in RTC SLOW Memory area.
   * It holds data marked with RTC_SLOW_ATTR attribute.
   * See the file "esp_attr.h" for more information.
   */
  .rtc.force_slow :
  {
    
 . = ALIGN(4); 
 _rtc_force_slow_start = ABSOLUTE(.);
    *(.rtc.force_slow .rtc.force_slow.*)
    
 . = ALIGN(4); 
 _rtc_force_slow_end = ABSOLUTE(.);
  } > rtc_slow_seg
  /**
   * This section holds RTC data that should have fixed addresses.
   * The data are not initialized at power-up and are retained during deep
   * sleep.
   */
  .rtc_reserved (NOLOAD):
  {
    
 . = ALIGN(4); 
 _rtc_reserved_start = ABSOLUTE(.);
    /**
     * New data can only be added here to ensure existing data are not moved.
     * Because data have adhered to the end of the segment and code is relied
     * on it.
     * >> put new data here <<
     */
    *(.rtc_timer_data_in_rtc_mem .rtc_timer_data_in_rtc_mem.*)
    KEEP(*(.bootloader_data_rtc_mem .bootloader_data_rtc_mem.*))
    _rtc_reserved_end = ABSOLUTE(.);
  } > rtc_reserved_seg
  _rtc_reserved_length = _rtc_reserved_end - _rtc_reserved_start;
  ASSERT((_rtc_reserved_length <= LENGTH(rtc_reserved_seg)),
          "RTC reserved segment data does not fit.")
  /* Get size of rtc slow data based on rtc_data_location alias */
  _rtc_slow_length = (ORIGIN(rtc_slow_seg) == ORIGIN(rtc_data_location))
                        ? (_rtc_force_slow_end - _rtc_data_start)
                        : (_rtc_force_slow_end - _rtc_force_slow_start);
  _rtc_fast_length = (ORIGIN(rtc_slow_seg) == ORIGIN(rtc_data_location))
                        ? (_rtc_force_fast_end - _rtc_fast_start)
                        : (_rtc_noinit_end - _rtc_fast_start);
  ASSERT((_rtc_slow_length <= LENGTH(rtc_slow_seg)),
          "RTC_SLOW segment data does not fit.")
  ASSERT((_rtc_fast_length <= LENGTH(rtc_data_seg)),
          "RTC_FAST segment data does not fit.")
  /* Send .iram0 code to iram */
  .iram0.vectors :
  {
    _iram_start = ABSOLUTE(.);
    /* Vectors go to IRAM */
    _vector_table = ABSOLUTE(.);
    . = 0x0;
    KEEP(*(.WindowVectors.text));
    . = 0x180;
    KEEP(*(.Level2InterruptVector.text));
    . = 0x1c0;
    KEEP(*(.Level3InterruptVector.text));
    . = 0x200;
    KEEP(*(.Level4InterruptVector.text));
    . = 0x240;
    KEEP(*(.Level5InterruptVector.text));
    . = 0x280;
    KEEP(*(.DebugExceptionVector.text));
    . = 0x2c0;
    KEEP(*(.NMIExceptionVector.text));
    . = 0x300;
    KEEP(*(.KernelExceptionVector.text));
    . = 0x340;
    KEEP(*(.UserExceptionVector.text));
    . = 0x3C0;
    KEEP(*(.DoubleExceptionVector.text));
    . = 0x400;
    KEEP(*(._invalid_pc_placeholder.text));
    *(.*Vector.literal)
  } > iram0_0_seg
  .iram0.text :
  {
    /* Code marked as running out of IRAM */
    _iram_text_start = ABSOLUTE(.);
    
 
 *(.iram1 .iram1.*)
 *libclang_rt.builtins.a:_divsf3.*(.literal .literal.* .text .text.*)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_append .text.gdma_append)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_default_rx_isr .text.gdma_default_rx_isr)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_default_tx_isr .text.gdma_default_tx_isr)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_reset .text.gdma_reset)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_start .text.gdma_start)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_stop .text.gdma_stop)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_check_end .text.gdma_link_check_end)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_concat .text.gdma_link_concat)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_count_buffer_size_till_eof .text.gdma_link_count_buffer_size_till_eof)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_get_buffer .text.gdma_link_get_buffer)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_get_head_addr .text.gdma_link_get_head_addr)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_get_length .text.gdma_link_get_length)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_mount_buffers .text.gdma_link_mount_buffers)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_set_length .text.gdma_link_set_length)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_set_owner .text.gdma_link_set_owner)
 *libesp_driver_gptimer.a:gptimer.*(.literal.gptimer_default_isr .text.gptimer_default_isr)
 *libesp_driver_i2c.a:i2c_master.*(.literal.i2c_master_isr_handler_default .text.i2c_master_isr_handler_default)
 *libesp_driver_mcpwm.a:mcpwm_cap.*(.literal.mcpwm_capture_default_isr .text.mcpwm_capture_default_isr)
 *libesp_driver_mcpwm.a:mcpwm_cmpr.*(.literal.mcpwm_comparator_default_isr .text.mcpwm_comparator_default_isr)
 *libesp_driver_mcpwm.a:mcpwm_fault.*(.literal.mcpwm_gpio_fault_default_isr .text.mcpwm_gpio_fault_default_isr)
 *libesp_driver_mcpwm.a:mcpwm_oper.*(.literal.mcpwm_operator_default_isr .text.mcpwm_operator_default_isr)
 *libesp_driver_mcpwm.a:mcpwm_timer.*(.literal.mcpwm_timer_default_isr .text.mcpwm_timer_default_isr)
 *libesp_driver_rmt.a:rmt_encoder.*(.literal.rmt_encoder_reset .text.rmt_encoder_reset)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_dma_rx_one_block_cb .text.rmt_dma_rx_one_block_cb)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_isr_handle_rx_done .text.rmt_isr_handle_rx_done)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_isr_handle_rx_threshold .text.rmt_isr_handle_rx_threshold)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_rx_default_isr .text.rmt_rx_default_isr)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_dma_tx_eof_cb .text.rmt_dma_tx_eof_cb)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_encode_check_result .text.rmt_encode_check_result)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_done .text.rmt_isr_handle_tx_done)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_loop_end .text.rmt_isr_handle_tx_loop_end)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_threshold .text.rmt_isr_handle_tx_threshold)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_default_isr .text.rmt_tx_default_isr)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_do_transaction .text.rmt_tx_do_transaction)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_mark_eof .text.rmt_tx_mark_eof)
 *libesp_event.a:default_event_loop.*(.literal.esp_event_isr_post .text.esp_event_isr_post)
 *libesp_event.a:esp_event.*(.literal.esp_event_isr_post_to .text.esp_event_isr_post_to)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_append .text.gdma_ahb_hal_append)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_clear_intr .text.gdma_ahb_hal_clear_intr)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_get_eof_desc_addr .text.gdma_ahb_hal_get_eof_desc_addr)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_read_intr_status .text.gdma_ahb_hal_read_intr_status)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_reset .text.gdma_ahb_hal_reset)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_start_with_desc .text.gdma_ahb_hal_start_with_desc)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_stop .text.gdma_ahb_hal_stop)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_append .text.gdma_hal_append)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_clear_intr .text.gdma_hal_clear_intr)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_get_eof_desc_addr .text.gdma_hal_get_eof_desc_addr)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_read_intr_status .text.gdma_hal_read_intr_status)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_reset .text.gdma_hal_reset)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_start_with_desc .text.gdma_hal_start_with_desc)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_stop .text.gdma_hal_stop)
 *libesp_hal_gpio.a:gpio_hal.*(.literal.gpio_hal_isolate_in_sleep .text.gpio_hal_isolate_in_sleep)
 *libesp_hal_gpspi.a:spi_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_gpspi.a:spi_slave_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_i2c.a:i2c_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_ledc.a:ledc_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_mspi.a:spi_flash_hal_gpspi.*(.literal .literal.* .text .text.*)
 *libesp_hal_mspi.a:spi_flash_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_regi2c.a:(.literal .literal.* .text .text.*)
 *libesp_hal_systimer.a:(.literal .literal.* .text .text.*)
 *libesp_hal_timg.a:timer_hal.*(.literal.timer_hal_capture_and_get_counter_value .text.timer_hal_capture_and_get_counter_value)
 *libesp_hal_wdt.a:rom_patch.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:clk_utils.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_compare_and_set .text.esp_cpu_compare_and_set)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_reset .text.esp_cpu_reset)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_stall .text.esp_cpu_stall)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_unstall .text.esp_cpu_unstall)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_wait_for_intr .text.esp_cpu_wait_for_intr)
 *libesp_hw_support.a:esp_clk_tree.*(.literal.esp_clk_tree_enable_power .text.esp_clk_tree_enable_power)
 *libesp_hw_support.a:esp_clk_tree.*(.literal.esp_clk_tree_enable_src .text.esp_clk_tree_enable_src)
 *libesp_hw_support.a:esp_clk_tree.*(.literal.esp_clk_tree_is_power_on .text.esp_clk_tree_is_power_on)
 *libesp_hw_support.a:esp_memory_utils.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:mspi_timing_by_mspi_delay.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:mspi_timing_config.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:mspi_timing_tuning.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_module_reset .text.periph_module_reset)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_acquire_enter .text.periph_rcc_acquire_enter)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_acquire_exit .text.periph_rcc_acquire_exit)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_enter .text.periph_rcc_enter)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_exit .text.periph_rcc_exit)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_release_enter .text.periph_rcc_release_enter)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_release_exit .text.periph_rcc_release_exit)
 *libesp_hw_support.a:periph_ctrl.*(.literal.wifi_module_disable .text.wifi_module_disable)
 *libesp_hw_support.a:periph_ctrl.*(.literal.wifi_module_enable .text.wifi_module_enable)
 *libesp_hw_support.a:regi2c_ctrl.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:rtc_clk.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:rtc_init.*(.literal.rtc_vddsdio_get_config .text.rtc_vddsdio_get_config)
 *libesp_hw_support.a:rtc_init.*(.literal.rtc_vddsdio_set_config .text.rtc_vddsdio_set_config)
 *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_pu .text.rtc_sleep_pu)
 *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_start .text.rtc_sleep_start)
 *libesp_hw_support.a:rtc_time.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:systimer.*(.literal .literal.* .text .text.*)
 *libesp_libc.a:abort.*(.literal .literal.* .text .text.*)
 *libesp_libc.a:assert.*(.literal .literal.* .text .text.*)
 *libesp_libc.a:heap.*(.literal .literal.* .text .text.*)
 *libesp_libc.a:stdatomic.*(.literal .literal.* .text .text.*)
 *libesp_mm.a:esp_cache_msync.*(.literal .literal.* .text .text.*)
 *libesp_mm.a:esp_cache_utils.*(.literal .literal.* .text .text.*)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvAcquireItemNoSplit .text.prvAcquireItemNoSplit)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCheckItemAvail .text.prvCheckItemAvail)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCheckItemFitsByteBuffer .text.prvCheckItemFitsByteBuffer)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCheckItemFitsDefault .text.prvCheckItemFitsDefault)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCopyItemAllowSplit .text.prvCopyItemAllowSplit)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCopyItemByteBuf .text.prvCopyItemByteBuf)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCopyItemNoSplit .text.prvCopyItemNoSplit)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvGetItemByteBuf .text.prvGetItemByteBuf)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvGetItemDefault .text.prvGetItemDefault)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvReceiveGenericFromISR .text.prvReceiveGenericFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvReturnItemByteBuf .text.prvReturnItemByteBuf)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvReturnItemDefault .text.prvReturnItemDefault)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvSendItemDoneNoSplit .text.prvSendItemDoneNoSplit)
 *libesp_ringbuf.a:ringbuf.*(.literal.vRingbufferReturnItemFromISR .text.vRingbufferReturnItemFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.xRingbufferReceiveFromISR .text.xRingbufferReceiveFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.xRingbufferReceiveSplitFromISR .text.xRingbufferReceiveSplitFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.xRingbufferReceiveUpToFromISR .text.xRingbufferReceiveUpToFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.xRingbufferSendFromISR .text.xRingbufferSendFromISR)
 *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_cache_writeback_esp32s3.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_print.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_spiflash.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_sys.*(.literal .literal.* .text .text.*)
 *libesp_system.a:esp_err.*(.literal .literal.* .text .text.*)
 *libesp_system.a:esp_system_chip.*(.literal.esp_system_abort .text.esp_system_abort)
 *libesp_system.a:freertos_hooks.*(.literal.esp_vApplicationTickHook .text.esp_vApplicationTickHook)
 *libesp_system.a:image_process.*(.literal .literal.* .text .text.*)
 *libesp_system.a:panic.*(.literal.panic_abort .text.panic_abort)
 *libesp_system.a:reset_reason.*(.literal.esp_reset_reason_set_hint .text.esp_reset_reason_set_hint)
 *libesp_system.a:system_internal.*(.literal.esp_restart_noos .text.esp_restart_noos)
 *libesp_system.a:system_internal.*(.literal.esp_system_reset_modules_on_exit .text.esp_system_reset_modules_on_exit)
 *libesp_system.a:system_time.*(.literal.esp_system_get_time .text.esp_system_get_time)
 *libesp_system.a:system_time.*(.literal.esp_system_get_time_resolution .text.esp_system_get_time_resolution)
 *libesp_system.a:ubsan.*(.literal .literal.* .text .text.*)
 *libesp_wifi.a:esp_adapter.*(.literal.coex_pti_get_wrapper .text.coex_pti_get_wrapper)
 *libesp_wifi.a:wifi_netif.*(.literal.wifi_sta_receive .text.wifi_sta_receive)
 *libesp_wifi.a:wifi_netif.*(.literal.wifi_transmit_wrap .text.wifi_transmit_wrap)
 *libfreertos.a:event_groups.*(.literal.xEventGroupGetBitsFromISR .text.xEventGroupGetBitsFromISR)
 *libfreertos.a:list.*(.literal.uxListRemove .text.uxListRemove)
 *libfreertos.a:list.*(.literal.vListInsertEnd .text.vListInsertEnd)
 *libfreertos.a:port.*(.literal.vPortAssertIfInISR .text.vPortAssertIfInISR)
 *libfreertos.a:port.*(.literal.vPortExitCritical .text.vPortExitCritical)
 *libfreertos.a:port.*(.literal.vPortSetStackWatchpoint .text.vPortSetStackWatchpoint)
 *libfreertos.a:port.*(.literal.vPortYieldOtherCore .text.vPortYieldOtherCore)
 *libfreertos.a:port.*(.literal.xPortEnterCriticalTimeout .text.xPortEnterCriticalTimeout)
 *libfreertos.a:port.*(.literal.xPortInIsrContext .text.xPortInIsrContext)
 *libfreertos.a:port.*(.literal.xPortInterruptedFromISRContext .text.xPortInterruptedFromISRContext)
 *libfreertos.a:port.*(.literal.xPortStartScheduler .text.xPortStartScheduler)
 *libfreertos.a:port_systick.*(.literal .literal.* .text .text.*)
 *libfreertos.a:portasm.*(.literal .literal.* .text .text.*)
 *libfreertos.a:queue.*(.literal.prvCopyDataFromQueue .text.prvCopyDataFromQueue)
 *libfreertos.a:queue.*(.literal.prvCopyDataToQueue .text.prvCopyDataToQueue)
 *libfreertos.a:queue.*(.literal.prvNotifyQueueSetContainer .text.prvNotifyQueueSetContainer)
 *libfreertos.a:queue.*(.literal.uxQueueMessagesWaitingFromISR .text.uxQueueMessagesWaitingFromISR)
 *libfreertos.a:queue.*(.literal.xQueueGenericSendFromISR .text.xQueueGenericSendFromISR)
 *libfreertos.a:queue.*(.literal.xQueueGetMutexHolderFromISR .text.xQueueGetMutexHolderFromISR)
 *libfreertos.a:queue.*(.literal.xQueueGiveFromISR .text.xQueueGiveFromISR)
 *libfreertos.a:queue.*(.literal.xQueueIsQueueEmptyFromISR .text.xQueueIsQueueEmptyFromISR)
 *libfreertos.a:queue.*(.literal.xQueueIsQueueFullFromISR .text.xQueueIsQueueFullFromISR)
 *libfreertos.a:queue.*(.literal.xQueuePeekFromISR .text.xQueuePeekFromISR)
 *libfreertos.a:queue.*(.literal.xQueueReceiveFromISR .text.xQueueReceiveFromISR)
 *libfreertos.a:queue.*(.literal.xQueueSelectFromSetFromISR .text.xQueueSelectFromSetFromISR)
 *libfreertos.a:stream_buffer.*(.literal.prvBytesInBuffer .text.prvBytesInBuffer)
 *libfreertos.a:stream_buffer.*(.literal.prvReadMessageFromBuffer .text.prvReadMessageFromBuffer)
 *libfreertos.a:stream_buffer.*(.literal.prvWriteMessageToBuffer .text.prvWriteMessageToBuffer)
 *libfreertos.a:stream_buffer.*(.literal.xStreamBufferReceiveCompletedFromISR .text.xStreamBufferReceiveCompletedFromISR)
 *libfreertos.a:stream_buffer.*(.literal.xStreamBufferReceiveFromISR .text.xStreamBufferReceiveFromISR)
 *libfreertos.a:stream_buffer.*(.literal.xStreamBufferSendCompletedFromISR .text.xStreamBufferSendCompletedFromISR)
 *libfreertos.a:stream_buffer.*(.literal.xStreamBufferSendFromISR .text.xStreamBufferSendFromISR)
 *libfreertos.a:tasks.*(.literal.prvCheckTaskCanBeScheduledSMP .text.prvCheckTaskCanBeScheduledSMP)
 *libfreertos.a:tasks.*(.literal.prvIsYieldRequiredSMP .text.prvIsYieldRequiredSMP)
 *libfreertos.a:tasks.*(.literal.prvResetNextTaskUnblockTime .text.prvResetNextTaskUnblockTime)
 *libfreertos.a:tasks.*(.literal.prvSelectHighestPriorityTaskSMP .text.prvSelectHighestPriorityTaskSMP)
 *libfreertos.a:tasks.*(.literal.prvTaskIsTaskSuspended .text.prvTaskIsTaskSuspended)
 *libfreertos.a:tasks.*(.literal.uxTaskPriorityGetFromISR .text.uxTaskPriorityGetFromISR)
 *libfreertos.a:tasks.*(.literal.vTaskGenericNotifyGiveFromISR .text.vTaskGenericNotifyGiveFromISR)
 *libfreertos.a:tasks.*(.literal.vTaskGetSnapshot .text.vTaskGetSnapshot)
 *libfreertos.a:tasks.*(.literal.vTaskSwitchContext .text.vTaskSwitchContext)
 *libfreertos.a:tasks.*(.literal.xTaskGenericNotifyFromISR .text.xTaskGenericNotifyFromISR)
 *libfreertos.a:tasks.*(.literal.xTaskGetSchedulerState .text.xTaskGetSchedulerState)
 *libfreertos.a:tasks.*(.literal.xTaskGetTickCount .text.xTaskGetTickCount)
 *libfreertos.a:tasks.*(.literal.xTaskGetTickCountFromISR .text.xTaskGetTickCountFromISR)
 *libfreertos.a:tasks.*(.literal.xTaskIncrementTick .text.xTaskIncrementTick)
 *libfreertos.a:tasks.*(.literal.xTaskIncrementTickOtherCores .text.xTaskIncrementTickOtherCores)
 *libfreertos.a:tasks.*(.literal.xTaskRemoveFromEventList .text.xTaskRemoveFromEventList)
 *libfreertos.a:tasks.*(.literal.xTaskResumeFromISR .text.xTaskResumeFromISR)
 *libfreertos.a:timers.*(.literal.xTimerGenericCommand .text.xTimerGenericCommand)
 *libfreertos.a:timers.*(.literal.xTimerPendFunctionCallFromISR .text.xTimerPendFunctionCallFromISR)
 *libgcc.a:_divsf3.*(.literal .literal.* .text .text.*)
 *libgcc.a:lib2funcs.*(.literal .literal.* .text .text.*)
 *libgcov.a:(.literal .literal.* .text .text.*)
 *libhal.a:cache_hal.*(.literal .literal.* .text .text.*)
 *libhal.a:mmu_hal.*(.literal .literal.* .text .text.*)
 *libheap.a:multi_heap.*(.literal.assert_valid_block .text.assert_valid_block)
 *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_impl .text.multi_heap_aligned_alloc_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_impl_offs .text.multi_heap_aligned_alloc_impl_offs)
 *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_offs .text.multi_heap_aligned_alloc_offs)
 *libheap.a:multi_heap.*(.literal.multi_heap_free_impl .text.multi_heap_free_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_allocated_size_impl .text.multi_heap_get_allocated_size_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_block_address_impl .text.multi_heap_get_block_address_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_first_block .text.multi_heap_get_first_block)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_full_block_size .text.multi_heap_get_full_block_size)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_next_block .text.multi_heap_get_next_block)
 *libheap.a:multi_heap.*(.literal.multi_heap_internal_lock .text.multi_heap_internal_lock)
 *libheap.a:multi_heap.*(.literal.multi_heap_internal_unlock .text.multi_heap_internal_unlock)
 *libheap.a:multi_heap.*(.literal.multi_heap_is_free .text.multi_heap_is_free)
 *libheap.a:multi_heap.*(.literal.multi_heap_malloc_impl .text.multi_heap_malloc_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_realloc_impl .text.multi_heap_realloc_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_set_lock .text.multi_heap_set_lock)
 *libheap.a:tlsf.*(.literal.tlsf_alloc_overhead .text.tlsf_alloc_overhead)
 *libheap.a:tlsf.*(.literal.tlsf_block_size .text.tlsf_block_size)
 *libheap.a:tlsf.*(.literal.tlsf_free .text.tlsf_free)
 *libheap.a:tlsf.*(.literal.tlsf_get_pool .text.tlsf_get_pool)
 *libheap.a:tlsf.*(.literal.tlsf_malloc .text.tlsf_malloc)
 *libheap.a:tlsf.*(.literal.tlsf_memalign .text.tlsf_memalign)
 *libheap.a:tlsf.*(.literal.tlsf_memalign_offs .text.tlsf_memalign_offs)
 *libheap.a:tlsf.*(.literal.tlsf_realloc .text.tlsf_realloc)
 *libheap.a:tlsf.*(.literal.tlsf_size .text.tlsf_size)
 *liblog.a:log.*(.literal .literal.* .text .text.*)
 *liblog.a:log_format_text.*(.literal .literal.* .text .text.*)
 *liblog.a:log_lock.*(.literal .literal.* .text .text.*)
 *liblog.a:log_print.*(.literal .literal.* .text .text.*)
 *liblog.a:log_timestamp.*(.literal.esp_log_early_timestamp .text.esp_log_early_timestamp)
 *liblog.a:log_timestamp.*(.literal.esp_log_timestamp .text.esp_log_timestamp)
 *liblog.a:log_timestamp_common.*(.literal .literal.* .text .text.*)
 *liblog.a:log_write.*(.literal.esp_log_write .text.esp_log_write)
 *liblog.a:log_write.*(.literal.esp_log_writev .text.esp_log_writev)
 *liblog.a:tag_log_level.*(.literal.esp_log_level_get_timeout .text.esp_log_level_get_timeout)
 *liblog.a:util.*(.literal .literal.* .text .text.*)
 *libnet80211.a:(.wifi0iram .wifi0iram.*)
 *libnet80211.a:(.wifirxiram .wifirxiram.*)
 *libnet80211.a:(.wifislprxiram .wifislprxiram.*)
 *libpp.a:(.wifi0iram .wifi0iram.*)
 *libpp.a:(.wifiorslpiram .wifiorslpiram.*)
 *libpp.a:(.wifirxiram .wifirxiram.*)
 *libpp.a:(.wifislprxiram .wifislprxiram.*)
 *librtc.a:(.literal .literal.* .text .text.*)
 *libsoc.a:lldesc.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:esp_flash_api.*(.literal.check_chip_pointer_default .text.check_chip_pointer_default)
 *libspi_flash.a:esp_flash_api.*(.literal.detect_spi_flash_chip .text.detect_spi_flash_chip)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_chip_driver_initialized .text.esp_flash_chip_driver_initialized)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_erase_chip .text.esp_flash_erase_chip)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_erase_region .text.esp_flash_erase_region)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_chip_write_protect .text.esp_flash_get_chip_write_protect)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_io_mode .text.esp_flash_get_io_mode)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_physical_size .text.esp_flash_get_physical_size)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_protected_region .text.esp_flash_get_protected_region)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_size .text.esp_flash_get_size)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_init .text.esp_flash_init)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_init_main .text.esp_flash_init_main)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_is_quad_mode .text.esp_flash_is_quad_mode)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_read .text.esp_flash_read)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_read_encrypted .text.esp_flash_read_encrypted)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_chip_write_protect .text.esp_flash_set_chip_write_protect)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_io_mode .text.esp_flash_set_io_mode)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_protected_region .text.esp_flash_set_protected_region)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_write .text.esp_flash_write)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_write_encrypted .text.esp_flash_write_encrypted)
 *libspi_flash.a:esp_flash_api.*(.literal.flash_end_flush_cache .text.flash_end_flush_cache)
 *libspi_flash.a:esp_flash_api.*(.literal.read_unique_id .text.read_unique_id)
 *libspi_flash.a:esp_flash_api.*(.literal.spiflash_end_default .text.spiflash_end_default)
 *libspi_flash.a:esp_flash_api.*(.literal.spiflash_start_core .text.spiflash_start_core)
 *libspi_flash.a:esp_flash_api.*(.literal.spiflash_start_default .text.spiflash_start_default)
 *libspi_flash.a:flash_brownout_hook.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:memspi_host_driver.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_boya.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_gd.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_generic.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_issi.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_mxic.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_mxic_opi.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_th.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_winbond.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_hpm_enable.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_oct_flash_init.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.delay_us .text.delay_us)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.get_buffer_malloc .text.get_buffer_malloc)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.main_flash_op_status .text.main_flash_op_status)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.main_flash_region_protected .text.main_flash_region_protected)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.release_buffer_malloc .text.release_buffer_malloc)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi23_end .text.spi23_end)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi23_start .text.spi23_start)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi_flash_os_check_yield .text.spi_flash_os_check_yield)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi_flash_os_yield .text.spi_flash_os_yield)
 *libspi_flash.a:spi_flash_os_func_noos.*(.literal.delay_us .text.delay_us)
 *libspi_flash.a:spi_flash_os_func_noos.*(.literal.esp_flash_app_disable_os_functions .text.esp_flash_app_disable_os_functions)
 *libspi_flash.a:spi_flash_os_func_noos.*(.literal.get_temp_buffer_not_supported .text.get_temp_buffer_not_supported)
 *libspi_flash.a:spi_flash_wrap.*(.literal .literal.* .text .text.*)
 *libxt_hal.a:(.literal .literal.* .text .text.*)
 *libxtensa.a:(EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .literal EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .literal.* EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .text EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .text.*)

  } > iram0_0_seg
  /**
   * This section is required to skip .iram0.text area because iram0_0_seg and
   * dram0_0_seg reflect the same address space on different buses.
   */
  .dram0.dummy (NOLOAD):
  {
    . = ORIGIN(dram0_0_seg) + ((_iram_end > _diram_i_start) ? (_iram_end - _diram_i_start) : 0);
  } > dram0_0_seg
  .dram0.data :
  {
    _data_start = ABSOLUTE(.);
    *(.gnu.linkonce.d.*)
    *(.data1)
    *(.sdata)
    *(.sdata.*)
    *(.gnu.linkonce.s.*)
    *(.gnu.linkonce.s2.*)
    *(.jcr)
    
 
 *(.data .data.*)
 *(.dram1 .dram1.*)
 *libclang_rt.builtins.a:_divsf3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_driver_dma.a:gdma_link.*(.rodata.gdma_link_mount_buffers .rodata.gdma_link_mount_buffers.str1.4 .sdata2.gdma_link_mount_buffers .srodata.gdma_link_mount_buffers)
 *libesp_driver_rmt.a:rmt_tx.*(.rodata.rmt_isr_handle_tx_done .rodata.rmt_isr_handle_tx_done.str1.4 .sdata2.rmt_isr_handle_tx_done .srodata.rmt_isr_handle_tx_done)
 *libesp_driver_rmt.a:rmt_tx.*(.rodata.rmt_tx_do_transaction .rodata.rmt_tx_do_transaction.str1.4 .sdata2.rmt_tx_do_transaction .srodata.rmt_tx_do_transaction)
 *libesp_hal_gpspi.a:spi_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_gpspi.a:spi_slave_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_i2c.a:i2c_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_ledc.a:ledc_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_mspi.a:spi_flash_hal_gpspi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_mspi.a:spi_flash_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_regi2c.a:(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_systimer.a:(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_wdt.a:rom_patch.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:clk_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:cpu.*(.rodata.esp_cpu_stall .rodata.esp_cpu_stall.str1.4 .sdata2.esp_cpu_stall .srodata.esp_cpu_stall)
 *libesp_hw_support.a:esp_memory_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:mspi_timing_by_mspi_delay.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:mspi_timing_config.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:mspi_timing_tuning.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:regi2c_ctrl.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:rtc_clk.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:systimer.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_libc.a:abort.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_libc.a:assert.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_libc.a:heap.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_libc.a:stdatomic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_mm.a:esp_cache_msync.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_mm.a:esp_cache_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_cache_writeback_esp32s3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_print.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_spiflash.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_sys.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_system.a:esp_err.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_system.a:image_process.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_system.a:reset_reason.*(.rodata.esp_reset_reason_set_hint .rodata.esp_reset_reason_set_hint.str1.4 .sdata2.esp_reset_reason_set_hint .srodata.esp_reset_reason_set_hint)
 *libesp_system.a:ubsan.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libgcc.a:_divsf3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libgcov.a:(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libhal.a:cache_hal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libhal.a:mmu_hal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libheap.a:multi_heap.*(.rodata.assert_valid_block .rodata.assert_valid_block.str1.4 .sdata2.assert_valid_block .srodata.assert_valid_block)
 *libheap.a:multi_heap.*(.rodata.multi_heap_get_first_block .rodata.multi_heap_get_first_block.str1.4 .sdata2.multi_heap_get_first_block .srodata.multi_heap_get_first_block)
 *libheap.a:multi_heap.*(.rodata.multi_heap_get_next_block .rodata.multi_heap_get_next_block.str1.4 .sdata2.multi_heap_get_next_block .srodata.multi_heap_get_next_block)
 *libheap.a:tlsf.*(.rodata.tlsf_free .rodata.tlsf_free.str1.4 .sdata2.tlsf_free .srodata.tlsf_free)
 *libheap.a:tlsf.*(.rodata.tlsf_malloc .rodata.tlsf_malloc.str1.4 .sdata2.tlsf_malloc .srodata.tlsf_malloc)
 *libheap.a:tlsf.*(.rodata.tlsf_memalign_offs .rodata.tlsf_memalign_offs.str1.4 .sdata2.tlsf_memalign_offs .srodata.tlsf_memalign_offs)
 *libheap.a:tlsf.*(.rodata.tlsf_realloc .rodata.tlsf_realloc.str1.4 .sdata2.tlsf_realloc .srodata.tlsf_realloc)
 *liblog.a:log.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:log_format_text.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:log_lock.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:log_print.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:log_timestamp_common.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:util.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libphy.a:(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libsoc.a:lldesc.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:flash_brownout_hook.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:memspi_host_driver.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_boya.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_gd.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_generic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_issi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_mxic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_mxic_opi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_th.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_winbond.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_hpm_enable.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_oct_flash_init.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_os_func_app.*(.rodata.spi_flash_os_check_yield .rodata.spi_flash_os_check_yield.str1.4 .sdata2.spi_flash_os_check_yield .srodata.spi_flash_os_check_yield)
 *libspi_flash.a:spi_flash_wrap.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)

    _data_end = ABSOLUTE(.);
  } > dram0_0_seg
  /**
   * This section holds data that should not be initialized at power up.
   * The section located in Internal SRAM memory region. The macro _NOINIT
   * can be used as attribute to place data into this section.
   * See the "esp_attr.h" file for more information.
   */
  .noinit (NOLOAD):
  {
    
 . = ALIGN(4); 
 _noinit_start = ABSOLUTE(.);
    *(.noinit .noinit.*)
    
 . = ALIGN(4); 
 _noinit_end = ABSOLUTE(.);
  } > dram0_0_seg
  /* Shared RAM */
  .dram0.bss (NOLOAD) :
  {
    
 . = ALIGN(8); 
 _bss_start = ABSOLUTE(.);
    
 *(.bss .bss.*)
 *(.dynbss .dynsbss .gnu.linkonce.b .gnu.linkonce.b.* .gnu.linkonce.sb .gnu.linkonce.sb.* .gnu.linkonce.sb2 .gnu.linkonce.sb2.* .sbss .sbss.* .sbss2 .sbss2.* .scommon .share.mem)
 *(.ext_ram.bss .ext_ram.bss.*)
 *(COMMON)
    
 . = ALIGN(16); 
 _bss_end = ABSOLUTE(.);
  } > dram0_0_seg
  ASSERT(((_bss_end - ORIGIN(dram0_0_seg)) <= LENGTH(dram0_0_seg)),
         "DRAM segment data does not fit.")
  .flash.text :
  {
    _stext = .;
    /**
     * Mark the start of flash.text.
     * This can be used by the MMU driver to maintain the virtual address.
     */
    _instruction_reserved_start = ABSOLUTE(.);
    _text_start = ABSOLUTE(.);
    
 
 *(EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_gptimer.a:gptimer.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_mcpwm.a:mcpwm_cap.* *libesp_driver_mcpwm.a:mcpwm_cmpr.* *libesp_driver_mcpwm.a:mcpwm_fault.* *libesp_driver_mcpwm.a:mcpwm_oper.* *libesp_driver_mcpwm.a:mcpwm_timer.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hal_dma.a:gdma_hal_ahb_v1.* *libesp_hal_dma.a:gdma_hal_top.* *libesp_hal_gpio.a:gpio_hal.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_timg.a:timer_hal.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk_tree.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_ringbuf.a:ringbuf.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:freertos_hooks.* *libesp_system.a:image_process.* *libesp_system.a:panic.* *libesp_system.a:reset_reason.* *libesp_system.a:system_internal.* *libesp_system.a:system_time.* *libesp_system.a:ubsan.* *libesp_wifi.a:esp_adapter.* *libesp_wifi.a:wifi_netif.* *libfreertos.a:event_groups.* *libfreertos.a:list.* *libfreertos.a:port.* *libfreertos.a:port_systick.* *libfreertos.a:portasm.* *libfreertos.a:queue.* *libfreertos.a:stream_buffer.* *libfreertos.a:tasks.* *libfreertos.a:timers.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.*) .literal EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_gptimer.a:gptimer.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_mcpwm.a:mcpwm_cap.* *libesp_driver_mcpwm.a:mcpwm_cmpr.* *libesp_driver_mcpwm.a:mcpwm_fault.* *libesp_driver_mcpwm.a:mcpwm_oper.* *libesp_driver_mcpwm.a:mcpwm_timer.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hal_dma.a:gdma_hal_ahb_v1.* *libesp_hal_dma.a:gdma_hal_top.* *libesp_hal_gpio.a:gpio_hal.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_timg.a:timer_hal.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk_tree.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_ringbuf.a:ringbuf.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:freertos_hooks.* *libesp_system.a:image_process.* *libesp_system.a:panic.* *libesp_system.a:reset_reason.* *libesp_system.a:system_internal.* *libesp_system.a:system_time.* *libesp_system.a:ubsan.* *libesp_wifi.a:esp_adapter.* *libesp_wifi.a:wifi_netif.* *libfreertos.a:event_groups.* *libfreertos.a:list.* *libfreertos.a:port.* *libfreertos.a:port_systick.* *libfreertos.a:portasm.* *libfreertos.a:queue.* *libfreertos.a:stream_buffer.* *libfreertos.a:tasks.* *libfreertos.a:timers.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.*) .literal.* EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_gptimer.a:gptimer.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_mcpwm.a:mcpwm_cap.* *libesp_driver_mcpwm.a:mcpwm_cmpr.* *libesp_driver_mcpwm.a:mcpwm_fault.* *libesp_driver_mcpwm.a:mcpwm_oper.* *libesp_driver_mcpwm.a:mcpwm_timer.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hal_dma.a:gdma_hal_ahb_v1.* *libesp_hal_dma.a:gdma_hal_top.* *libesp_hal_gpio.a:gpio_hal.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_timg.a:timer_hal.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk_tree.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_ringbuf.a:ringbuf.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:freertos_hooks.* *libesp_system.a:image_process.* *libesp_system.a:panic.* *libesp_system.a:reset_reason.* *libesp_system.a:system_internal.* *libesp_system.a:system_time.* *libesp_system.a:ubsan.* *libesp_wifi.a:esp_adapter.* *libesp_wifi.a:wifi_netif.* *libfreertos.a:event_groups.* *libfreertos.a:list.* *libfreertos.a:port.* *libfreertos.a:port_systick.* *libfreertos.a:portasm.* *libfreertos.a:queue.* *libfreertos.a:stream_buffer.* *libfreertos.a:tasks.* *libfreertos.a:timers.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.*) .text EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_gptimer.a:gptimer.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_mcpwm.a:mcpwm_cap.* *libesp_driver_mcpwm.a:mcpwm_cmpr.* *libesp_driver_mcpwm.a:mcpwm_fault.* *libesp_driver_mcpwm.a:mcpwm_oper.* *libesp_driver_mcpwm.a:mcpwm_timer.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hal_dma.a:gdma_hal_ahb_v1.* *libesp_hal_dma.a:gdma_hal_top.* *libesp_hal_gpio.a:gpio_hal.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_timg.a:timer_hal.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk_tree.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_ringbuf.a:ringbuf.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:freertos_hooks.* *libesp_system.a:image_process.* *libesp_system.a:panic.* *libesp_system.a:reset_reason.* *libesp_system.a:system_internal.* *libesp_system.a:system_time.* *libesp_system.a:ubsan.* *libesp_wifi.a:esp_adapter.* *libesp_wifi.a:wifi_netif.* *libfreertos.a:event_groups.* *libfreertos.a:list.* *libfreertos.a:port.* *libfreertos.a:port_systick.* *libfreertos.a:portasm.* *libfreertos.a:queue.* *libfreertos.a:stream_buffer.* *libfreertos.a:tasks.* *libfreertos.a:timers.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.*) .text.*)
 *(EXCLUDE_FILE(*libnet80211.a *libpp.a) .wifi0iram EXCLUDE_FILE(*libnet80211.a *libpp.a) .wifi0iram.*)
 *(.wifiextrairam .wifiextrairam.*)
 *(EXCLUDE_FILE(*libpp.a) .wifiorslpiram EXCLUDE_FILE(*libpp.a) .wifiorslpiram.*)
 *(EXCLUDE_FILE(*libnet80211.a *libpp.a) .wifirxiram EXCLUDE_FILE(*libnet80211.a *libpp.a) .wifirxiram.*)
 *(.wifislpiram .wifislpiram.*)
 *(EXCLUDE_FILE(*libnet80211.a *libpp.a) .wifislprxiram EXCLUDE_FILE(*libnet80211.a *libpp.a) .wifislprxiram.*)
 *libesp_driver_dma.a:gdma.*(.literal.do_allocate_gdma_channel .literal.gdma_apply_strategy .literal.gdma_config_transfer .literal.gdma_connect .literal.gdma_del_channel .literal.gdma_del_rx_channel .literal.gdma_del_tx_channel .literal.gdma_disconnect .literal.gdma_get_free_m2m_trig_id_mask .literal.gdma_install_rx_interrupt .literal.gdma_install_tx_interrupt .literal.gdma_new_ahb_channel .literal.gdma_register_rx_event_callbacks .literal.gdma_register_tx_event_callbacks .literal.gdma_set_priority .literal.gdma_try_alloc_group_handle .literal.gdma_try_alloc_pair_handle .literal.gdma_try_free_group_handle .literal.gdma_try_free_pair_handle .text .text.do_allocate_gdma_channel .text.gdma_apply_strategy .text.gdma_config_transfer .text.gdma_connect .text.gdma_del_channel .text.gdma_del_rx_channel .text.gdma_del_tx_channel .text.gdma_disconnect .text.gdma_get_alignment_constraints .text.gdma_get_free_m2m_trig_id_mask .text.gdma_get_group_channel_id .text.gdma_install_rx_interrupt .text.gdma_install_tx_interrupt .text.gdma_new_ahb_channel .text.gdma_register_rx_event_callbacks .text.gdma_register_tx_event_callbacks .text.gdma_set_priority .text.gdma_try_alloc_group_handle .text.gdma_try_alloc_pair_handle .text.gdma_try_free_group_handle .text.gdma_try_free_pair_handle)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_del_link_list .literal.gdma_new_link_list .text .text.gdma_del_link_list .text.gdma_link_get_owner .text.gdma_new_link_list)
 *libesp_driver_gptimer.a:gptimer.*(.literal.gptimer_del_timer .literal.gptimer_destroy .literal.gptimer_disable .literal.gptimer_enable .literal.gptimer_get_captured_count .literal.gptimer_get_raw_count .literal.gptimer_get_resolution .literal.gptimer_new_timer .literal.gptimer_register_event_callbacks .literal.gptimer_register_to_group .literal.gptimer_set_alarm_action .literal.gptimer_set_raw_count .literal.gptimer_start .literal.gptimer_stop .literal.gptimer_unregister_from_group .text .text.gptimer_del_timer .text.gptimer_destroy .text.gptimer_disable .text.gptimer_enable .text.gptimer_get_captured_count .text.gptimer_get_raw_count .text.gptimer_get_resolution .text.gptimer_new_timer .text.gptimer_register_event_callbacks .text.gptimer_register_to_group .text.gptimer_set_alarm_action .text.gptimer_set_raw_count .text.gptimer_start .text.gptimer_stop .text.gptimer_unregister_from_group)
 *libesp_driver_i2c.a:i2c_master.*(.literal.i2c_del_master_bus .literal.i2c_master_bus_add_device .literal.i2c_master_bus_destroy .literal.i2c_master_bus_reset .literal.i2c_master_bus_rm_device .literal.i2c_master_bus_wait_all_done .literal.i2c_master_device_change_address .literal.i2c_master_execute_defined_operations .literal.i2c_master_get_bus_handle .literal.i2c_master_multi_buffer_transmit .literal.i2c_master_probe .literal.i2c_master_receive .literal.i2c_master_register_event_callbacks .literal.i2c_master_transmit .literal.i2c_master_transmit_receive .literal.i2c_new_master_bus .literal.i2c_param_master_config .literal.s_i2c_asynchronous_transaction .literal.s_i2c_err_log_print .literal.s_i2c_hw_fsm_reset .literal.s_i2c_master_clear_bus .literal.s_i2c_read_command .literal.s_i2c_send_command_async .literal.s_i2c_send_commands .literal.s_i2c_start_end_command .literal.s_i2c_synchronous_transaction .literal.s_i2c_transaction_start .literal.s_i2c_write_command .text .text.i2c_del_master_bus .text.i2c_master_bus_add_device .text.i2c_master_bus_destroy .text.i2c_master_bus_reset .text.i2c_master_bus_rm_device .text.i2c_master_bus_wait_all_done .text.i2c_master_device_change_address .text.i2c_master_execute_defined_operations .text.i2c_master_get_bus_handle .text.i2c_master_multi_buffer_transmit .text.i2c_master_probe .text.i2c_master_receive .text.i2c_master_register_event_callbacks .text.i2c_master_transmit .text.i2c_master_transmit_receive .text.i2c_new_master_bus .text.i2c_param_master_config .text.s_i2c_asynchronous_transaction .text.s_i2c_err_log_print .text.s_i2c_hw_fsm_reset .text.s_i2c_master_clear_bus .text.s_i2c_read_command .text.s_i2c_send_command_async .text.s_i2c_send_commands .text.s_i2c_start_end_command .text.s_i2c_synchronous_transaction .text.s_i2c_transaction_start .text.s_i2c_write_command)
 *libesp_driver_mcpwm.a:mcpwm_cap.*(.literal.mcpwm_cap_timer_destroy .literal.mcpwm_cap_timer_register_to_group .literal.mcpwm_cap_timer_unregister_from_group .literal.mcpwm_capture_channel_destroy .literal.mcpwm_capture_channel_disable .literal.mcpwm_capture_channel_enable .literal.mcpwm_capture_channel_register_event_callbacks .literal.mcpwm_capture_channel_register_to_timer .literal.mcpwm_capture_channel_trigger_soft_catch .literal.mcpwm_capture_channel_unregister_from_timer .literal.mcpwm_capture_get_latched_value .literal.mcpwm_capture_timer_disable .literal.mcpwm_capture_timer_enable .literal.mcpwm_capture_timer_get_resolution .literal.mcpwm_capture_timer_set_phase_on_sync .literal.mcpwm_capture_timer_start .literal.mcpwm_capture_timer_stop .literal.mcpwm_del_capture_channel .literal.mcpwm_del_capture_timer .literal.mcpwm_ll_capture_set_prescale .literal.mcpwm_new_capture_channel .literal.mcpwm_new_capture_timer .text .text.mcpwm_cap_timer_destroy .text.mcpwm_cap_timer_register_to_group .text.mcpwm_cap_timer_unregister_from_group .text.mcpwm_capture_channel_destroy .text.mcpwm_capture_channel_disable .text.mcpwm_capture_channel_enable .text.mcpwm_capture_channel_register_event_callbacks .text.mcpwm_capture_channel_register_to_timer .text.mcpwm_capture_channel_trigger_soft_catch .text.mcpwm_capture_channel_unregister_from_timer .text.mcpwm_capture_get_latched_value .text.mcpwm_capture_timer_disable .text.mcpwm_capture_timer_enable .text.mcpwm_capture_timer_get_resolution .text.mcpwm_capture_timer_set_phase_on_sync .text.mcpwm_capture_timer_start .text.mcpwm_capture_timer_stop .text.mcpwm_del_capture_channel .text.mcpwm_del_capture_timer .text.mcpwm_ll_capture_set_prescale .text.mcpwm_new_capture_channel .text.mcpwm_new_capture_timer)
 *libesp_driver_mcpwm.a:mcpwm_cmpr.*(.literal.mcpwm_comparator_destroy .literal.mcpwm_comparator_register_event_callbacks .literal.mcpwm_comparator_register_to_operator .literal.mcpwm_comparator_set_compare_value .literal.mcpwm_comparator_unregister_from_operator .literal.mcpwm_del_comparator .literal.mcpwm_new_comparator .text .text.mcpwm_comparator_destroy .text.mcpwm_comparator_register_event_callbacks .text.mcpwm_comparator_register_to_operator .text.mcpwm_comparator_set_compare_value .text.mcpwm_comparator_unregister_from_operator .text.mcpwm_del_comparator .text.mcpwm_ll_operator_enable_update_compare_on_sync .text.mcpwm_ll_operator_enable_update_compare_on_tep .text.mcpwm_ll_operator_enable_update_compare_on_tez .text.mcpwm_new_comparator)
 *libesp_driver_mcpwm.a:mcpwm_fault.*(.literal.mcpwm_del_fault .literal.mcpwm_del_gpio_fault .literal.mcpwm_del_soft_fault .literal.mcpwm_fault_register_event_callbacks .literal.mcpwm_gpio_fault_destroy .literal.mcpwm_gpio_fault_register_to_group .literal.mcpwm_gpio_fault_unregister_from_group .literal.mcpwm_new_gpio_fault .literal.mcpwm_new_soft_fault .literal.mcpwm_soft_fault_activate .text .text.mcpwm_del_fault .text.mcpwm_del_gpio_fault .text.mcpwm_del_soft_fault .text.mcpwm_fault_register_event_callbacks .text.mcpwm_gpio_fault_destroy .text.mcpwm_gpio_fault_register_to_group .text.mcpwm_gpio_fault_unregister_from_group .text.mcpwm_ll_fault_set_active_level .text.mcpwm_new_gpio_fault .text.mcpwm_new_soft_fault .text.mcpwm_soft_fault_activate)
 *libesp_driver_mcpwm.a:mcpwm_oper.*(.literal.mcpwm_del_operator .literal.mcpwm_ll_carrier_set_first_pulse_width .literal.mcpwm_ll_carrier_set_prescale .literal.mcpwm_new_operator .literal.mcpwm_operator_apply_carrier .literal.mcpwm_operator_connect_timer .literal.mcpwm_operator_destroy .literal.mcpwm_operator_recover_from_fault .literal.mcpwm_operator_register_event_callbacks .literal.mcpwm_operator_register_to_group .literal.mcpwm_operator_set_brake_on_fault .literal.mcpwm_operator_unregister_from_group .text .text.mcpwm_del_operator .text.mcpwm_ll_brake_enable_cbc_mode .text.mcpwm_ll_brake_enable_oneshot_mode .text.mcpwm_ll_carrier_set_first_pulse_width .text.mcpwm_ll_carrier_set_prescale .text.mcpwm_ll_deadtime_enable_update_delay_on_sync .text.mcpwm_ll_deadtime_enable_update_delay_on_tep .text.mcpwm_ll_deadtime_enable_update_delay_on_tez .text.mcpwm_new_operator .text.mcpwm_operator_apply_carrier .text.mcpwm_operator_connect_timer .text.mcpwm_operator_destroy .text.mcpwm_operator_recover_from_fault .text.mcpwm_operator_register_event_callbacks .text.mcpwm_operator_register_to_group .text.mcpwm_operator_set_brake_on_fault .text.mcpwm_operator_unregister_from_group)
 *libesp_driver_mcpwm.a:mcpwm_timer.*(.literal.mcpwm_del_timer .literal.mcpwm_ll_timer_set_clock_prescale .literal.mcpwm_ll_timer_set_count_mode .literal.mcpwm_ll_timer_set_start_stop_command .literal.mcpwm_new_timer .literal.mcpwm_timer_destroy .literal.mcpwm_timer_disable .literal.mcpwm_timer_enable .literal.mcpwm_timer_get_phase .literal.mcpwm_timer_register_event_callbacks .literal.mcpwm_timer_register_to_group .literal.mcpwm_timer_set_period .literal.mcpwm_timer_set_phase_on_sync .literal.mcpwm_timer_start_stop .literal.mcpwm_timer_unregister_from_group .text .text.mcpwm_del_timer .text.mcpwm_ll_timer_set_clock_prescale .text.mcpwm_ll_timer_set_count_mode .text.mcpwm_ll_timer_set_start_stop_command .text.mcpwm_new_timer .text.mcpwm_timer_destroy .text.mcpwm_timer_disable .text.mcpwm_timer_enable .text.mcpwm_timer_get_phase .text.mcpwm_timer_register_event_callbacks .text.mcpwm_timer_register_to_group .text.mcpwm_timer_set_period .text.mcpwm_timer_set_phase_on_sync .text.mcpwm_timer_start_stop .text.mcpwm_timer_unregister_from_group)
 *libesp_driver_rmt.a:rmt_encoder.*(.literal.rmt_alloc_encoder_mem .literal.rmt_del_encoder .text .text.rmt_alloc_encoder_mem .text.rmt_del_encoder)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_del_rx_channel .literal.rmt_ll_rx_enable_dma .literal.rmt_ll_rx_set_carrier_high_low_ticks .literal.rmt_new_rx_channel .literal.rmt_receive .literal.rmt_rx_demodulate_carrier .literal.rmt_rx_destroy .literal.rmt_rx_disable .literal.rmt_rx_enable .literal.rmt_rx_init_dma_link .literal.rmt_rx_register_event_callbacks .literal.rmt_rx_register_to_group .literal.rmt_rx_unregister_from_group .text .text.rmt_del_rx_channel .text.rmt_ll_rx_enable_dma .text.rmt_ll_rx_set_carrier_high_low_ticks .text.rmt_new_rx_channel .text.rmt_receive .text.rmt_rx_demodulate_carrier .text.rmt_rx_destroy .text.rmt_rx_disable .text.rmt_rx_enable .text.rmt_rx_init_dma_link .text.rmt_rx_register_event_callbacks .text.rmt_rx_register_to_group .text.rmt_rx_unregister_from_group)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_del_sync_manager .literal.rmt_del_tx_channel .literal.rmt_ll_tx_enable_dma .literal.rmt_ll_tx_set_carrier_high_low_ticks .literal.rmt_new_sync_manager .literal.rmt_new_tx_channel .literal.rmt_sync_reset .literal.rmt_transmit .literal.rmt_tx_create_trans_queue .literal.rmt_tx_destroy .literal.rmt_tx_disable .literal.rmt_tx_enable .literal.rmt_tx_init_dma_link .literal.rmt_tx_modulate_carrier .literal.rmt_tx_register_event_callbacks .literal.rmt_tx_register_to_group .literal.rmt_tx_switch_gpio .literal.rmt_tx_unregister_from_group .literal.rmt_tx_wait_all_done .text .text.rmt_del_sync_manager .text.rmt_del_tx_channel .text.rmt_ll_tx_enable_dma .text.rmt_ll_tx_set_carrier_high_low_ticks .text.rmt_new_sync_manager .text.rmt_new_tx_channel .text.rmt_sync_reset .text.rmt_transmit .text.rmt_tx_create_trans_queue .text.rmt_tx_destroy .text.rmt_tx_disable .text.rmt_tx_enable .text.rmt_tx_init_dma_link .text.rmt_tx_modulate_carrier .text.rmt_tx_register_event_callbacks .text.rmt_tx_register_to_group .text.rmt_tx_switch_gpio .text.rmt_tx_unregister_from_group .text.rmt_tx_wait_all_done)
 *libesp_event.a:default_event_loop.*(.literal.esp_event_handler_instance_register .literal.esp_event_handler_instance_unregister .literal.esp_event_handler_register .literal.esp_event_handler_unregister .literal.esp_event_loop_create_default .literal.esp_event_loop_delete_default .literal.esp_event_post .text .text.esp_event_handler_instance_register .text.esp_event_handler_instance_unregister .text.esp_event_handler_register .text.esp_event_handler_unregister .text.esp_event_loop_create_default .text.esp_event_loop_delete_default .text.esp_event_post)
 *libesp_event.a:esp_event.*(.literal.base_node_add_handler .literal.base_node_remove_all_handler .literal.base_node_remove_handler .literal.esp_event_handler_instance_register_with .literal.esp_event_handler_instance_unregister_with .literal.esp_event_handler_register_with .literal.esp_event_handler_register_with_internal .literal.esp_event_handler_unregister_with .literal.esp_event_handler_unregister_with_internal .literal.esp_event_loop_create .literal.esp_event_loop_delete .literal.esp_event_loop_run .literal.esp_event_loop_run_task .literal.esp_event_post_to .literal.find_and_unregister_handler .literal.handler_instances_add .literal.handler_instances_remove .literal.handler_instances_remove_all .literal.loop_node_add_handler .literal.loop_node_remove_all_handler .literal.loop_node_remove_handler .literal.loop_remove_handler .text .text.base_node_add_handler .text.base_node_remove_all_handler .text.base_node_remove_handler .text.esp_event_dump .text.esp_event_handler_instance_register_with .text.esp_event_handler_instance_unregister_with .text.esp_event_handler_register_with .text.esp_event_handler_register_with_internal .text.esp_event_handler_unregister_with .text.esp_event_handler_unregister_with_internal .text.esp_event_loop_create .text.esp_event_loop_delete .text.esp_event_loop_run .text.esp_event_loop_run_task .text.esp_event_post_to .text.find_and_unregister_handler .text.handler_execute .text.handler_instances_add .text.handler_instances_remove .text.handler_instances_remove_all .text.loop_node_add_handler .text.loop_node_remove_all_handler .text.loop_node_remove_handler .text.loop_remove_handler)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_init .literal.gdma_ahb_hal_set_burst_size .literal.gdma_ahb_hal_set_strategy .literal.gdma_ll_rx_set_burst_size .literal.gdma_ll_tx_set_burst_size .text .text.gdma_ahb_hal_connect_mem .text.gdma_ahb_hal_connect_peri .text.gdma_ahb_hal_disconnect_all .text.gdma_ahb_hal_enable_burst .text.gdma_ahb_hal_enable_intr .text.gdma_ahb_hal_get_intr_status_reg .text.gdma_ahb_hal_init .text.gdma_ahb_hal_set_burst_size .text.gdma_ahb_hal_set_priority .text.gdma_ahb_hal_set_strategy .text.gdma_ll_rx_set_burst_size .text.gdma_ll_tx_set_burst_size)
 *libesp_hal_dma.a:gdma_hal_top.*(.text .text.gdma_hal_connect_mem .text.gdma_hal_connect_peri .text.gdma_hal_deinit .text.gdma_hal_disconnect_all .text.gdma_hal_enable_burst .text.gdma_hal_enable_intr .text.gdma_hal_get_intr_status_reg .text.gdma_hal_set_burst_size .text.gdma_hal_set_priority .text.gdma_hal_set_strategy)
 *libesp_hal_gpio.a:gpio_hal.*(.literal.gpio_hal_intr_disable .literal.gpio_hal_intr_enable_on_core .literal.gpio_hal_iomux_in .literal.gpio_hal_iomux_out .literal.gpio_hal_matrix_in .literal.gpio_hal_matrix_out .text .text.gpio_hal_intr_disable .text.gpio_hal_intr_enable_on_core .text.gpio_hal_iomux_in .text.gpio_hal_iomux_out .text.gpio_hal_matrix_in .text.gpio_hal_matrix_out)
 *libesp_hal_timg.a:timer_hal.*(.literal.timer_hal_deinit .literal.timer_hal_init .literal.timer_hal_set_counter_value .text .text.timer_hal_deinit .text.timer_hal_init .text.timer_hal_set_counter_value)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_set_watchpoint .text .text.esp_cpu_clear_breakpoint .text.esp_cpu_clear_watchpoint .text.esp_cpu_set_breakpoint .text.esp_cpu_set_watchpoint)
 *libesp_hw_support.a:esp_clk_tree.*(.literal.esp_clk_tree_src_get_freq_hz .text .text.esp_clk_tree_initialize .text.esp_clk_tree_src_get_freq_hz)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_ll_disable_clk_set_rst .literal.periph_ll_enable_clk_clear_rst .literal.periph_ll_get_clk_en_mask .literal.periph_ll_get_rst_en_mask .literal.periph_ll_reset .literal.periph_module_disable .literal.periph_module_enable .text .text.periph_ll_disable_clk_set_rst .text.periph_ll_enable_clk_clear_rst .text.periph_ll_get_clk_en_mask .text.periph_ll_get_rst_en_mask .text.periph_ll_reset .text.periph_module_disable .text.periph_module_enable)
 *libesp_hw_support.a:rtc_init.*(.literal.calibrate_ocode .literal.get_dig1v3_dbias_by_efuse .literal.get_dig_dbias_by_efuse .literal.get_rtc_dbias_by_efuse .literal.rtc_init .literal.rtc_set_stored_dbias .literal.set_ocode_by_efuse .text .text.calibrate_ocode .text.get_dig1v3_dbias_by_efuse .text.get_dig_dbias_by_efuse .text.get_rtc_dbias_by_efuse .text.rtc_init .text.rtc_set_stored_dbias .text.set_ocode_by_efuse)
 *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_get_default_config .literal.rtc_sleep_init .literal.rtc_sleep_low_init .text .text.rtc_sleep_get_default_config .text.rtc_sleep_init .text.rtc_sleep_low_init)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvGetFreeSize .literal.prvInitializeNewRingbuffer .literal.prvReceiveGeneric .literal.prvSendAcquireGeneric .literal.vRingbufferDelete .literal.vRingbufferDeleteWithCaps .literal.vRingbufferGetInfo .literal.vRingbufferReset .literal.vRingbufferReturnItem .literal.xRingbufferAddToQueueSetRead .literal.xRingbufferCreate .literal.xRingbufferCreateNoSplit .literal.xRingbufferCreateStatic .literal.xRingbufferCreateWithCaps .literal.xRingbufferGetCurFreeSize .literal.xRingbufferGetMaxItemSize .literal.xRingbufferGetStaticBuffer .literal.xRingbufferPrintInfo .literal.xRingbufferReceive .literal.xRingbufferReceiveSplit .literal.xRingbufferReceiveUpTo .literal.xRingbufferRemoveFromQueueSetRead .literal.xRingbufferSend .literal.xRingbufferSendAcquire .literal.xRingbufferSendComplete .text .text.prvGetCurMaxSizeAllowSplit .text.prvGetCurMaxSizeByteBuf .text.prvGetCurMaxSizeNoSplit .text.prvGetFreeSize .text.prvInitializeNewRingbuffer .text.prvReceiveGeneric .text.prvSendAcquireGeneric .text.vRingbufferDelete .text.vRingbufferDeleteWithCaps .text.vRingbufferGetInfo .text.vRingbufferReset .text.vRingbufferReturnItem .text.xRingbufferAddToQueueSetRead .text.xRingbufferCreate .text.xRingbufferCreateNoSplit .text.xRingbufferCreateStatic .text.xRingbufferCreateWithCaps .text.xRingbufferGetCurFreeSize .text.xRingbufferGetMaxItemSize .text.xRingbufferGetStaticBuffer .text.xRingbufferPrintInfo .text.xRingbufferReceive .text.xRingbufferReceiveSplit .text.xRingbufferReceiveUpTo .text.xRingbufferRemoveFromQueueSetRead .text.xRingbufferSend .text.xRingbufferSendAcquire .text.xRingbufferSendComplete)
 *libesp_system.a:esp_system_chip.*(.literal.esp_get_free_heap_size .literal.esp_get_free_internal_heap_size .literal.esp_get_idf_version .literal.esp_get_minimum_free_heap_size .text .text.esp_get_free_heap_size .text.esp_get_free_internal_heap_size .text.esp_get_idf_version .text.esp_get_minimum_free_heap_size)
 *libesp_system.a:freertos_hooks.*(.literal.esp_deregister_freertos_idle_hook .literal.esp_deregister_freertos_idle_hook_for_cpu .literal.esp_deregister_freertos_tick_hook .literal.esp_deregister_freertos_tick_hook_for_cpu .literal.esp_register_freertos_idle_hook .literal.esp_register_freertos_idle_hook_for_cpu .literal.esp_register_freertos_tick_hook .literal.esp_register_freertos_tick_hook_for_cpu .literal.esp_vApplicationIdleHook .text .text.esp_deregister_freertos_idle_hook .text.esp_deregister_freertos_idle_hook_for_cpu .text.esp_deregister_freertos_tick_hook .text.esp_deregister_freertos_tick_hook_for_cpu .text.esp_register_freertos_idle_hook .text.esp_register_freertos_idle_hook_for_cpu .text.esp_register_freertos_tick_hook .text.esp_register_freertos_tick_hook_for_cpu .text.esp_vApplicationIdleHook)
 *libesp_system.a:panic.*(.literal.disable_all_wdts .literal.esp_panic_handler .literal.esp_panic_handler_disable_timg_wdts .literal.esp_panic_handler_enable_rtc_wdt .literal.esp_panic_handler_feed_wdts .literal.esp_panic_handler_increment_entry_count .literal.panic_print_char .literal.panic_print_char_uart .literal.panic_print_char_usb_serial_jtag .literal.panic_print_dec .literal.panic_print_hex .literal.panic_print_str .literal.print_abort_details .text .text.disable_all_wdts .text.esp_panic_handler .text.esp_panic_handler_disable_timg_wdts .text.esp_panic_handler_enable_rtc_wdt .text.esp_panic_handler_feed_wdts .text.esp_panic_handler_increment_entry_count .text.esp_reset_reason_get_hint .text.esp_reset_reason_set_hint .text.panic_print_char .text.panic_print_char_uart .text.panic_print_char_usb_serial_jtag .text.panic_print_dec .text.panic_print_hex .text.panic_print_str .text.print_abort_details)
 *libesp_system.a:reset_reason.*(.literal.esp_reset_reason .literal.esp_reset_reason_clear_hint .literal.esp_reset_reason_get_hint .literal.esp_reset_reason_init .text .text.esp_reset_reason .text.esp_reset_reason_clear_hint .text.esp_reset_reason_get_hint .text.esp_reset_reason_init .text.get_reset_reason)
 *libesp_system.a:system_internal.*(.text)
 *libesp_system.a:system_time.*(.text)
 *libesp_wifi.a:esp_adapter.*(.literal.esp_cpu_intr_disable .literal.esp_cpu_intr_enable .literal.esp_event_post_wrapper .literal.esp_phy_disable_wrapper .literal.esp_phy_enable_wrapper .literal.event_group_wait_bits_wrapper .literal.get_time_wrapper .literal.mutex_create_wrapper .literal.mutex_delete_wrapper .literal.queue_create_wrapper .literal.queue_delete_wrapper .literal.queue_recv_wrapper .literal.queue_send_to_back_wrapper .literal.queue_send_to_front_wrapper .literal.queue_send_wrapper .literal.recursive_mutex_create_wrapper .literal.set_intr_wrapper .literal.set_isr_wrapper .literal.task_create_pinned_to_core_wrapper .literal.task_create_wrapper .literal.wifi_clock_disable_wrapper .literal.wifi_clock_enable_wrapper .literal.wifi_create_queue .literal.wifi_create_queue_wrapper .literal.wifi_delete_queue .literal.wifi_delete_queue_wrapper .literal.wifi_reset_mac_wrapper .literal.wifi_thread_semphr_free .literal.wifi_thread_semphr_get_wrapper .text .text.clear_intr_wrapper .text.coex_deinit_wrapper .text.coex_disable_wrapper .text.coex_enable_wrapper .text.coex_init_wrapper .text.coex_register_start_cb_wrapper .text.coex_schm_curr_period_get_wrapper .text.coex_schm_curr_phase_get_wrapper .text.coex_schm_flexible_period_get_wrapper .text.coex_schm_flexible_period_set_wrapper .text.coex_schm_get_phase_by_idx_wrapper .text.coex_schm_interval_get_wrapper .text.coex_schm_process_restart_wrapper .text.coex_schm_register_cb_wrapper .text.coex_schm_status_bit_clear_wrapper .text.coex_schm_status_bit_set_wrapper .text.coex_wifi_channel_set_wrapper .text.coex_wifi_request_wrapper .text.esp_cpu_intr_disable .text.esp_cpu_intr_enable .text.esp_event_post_wrapper .text.esp_phy_disable_wrapper .text.esp_phy_enable_wrapper .text.event_group_wait_bits_wrapper .text.get_time_wrapper .text.mutex_create_wrapper .text.mutex_delete_wrapper .text.queue_create_wrapper .text.queue_delete_wrapper .text.queue_recv_wrapper .text.queue_send_to_back_wrapper .text.queue_send_to_front_wrapper .text.queue_send_wrapper .text.recursive_mutex_create_wrapper .text.set_intr_wrapper .text.set_isr_wrapper .text.task_create_pinned_to_core_wrapper .text.task_create_wrapper .text.task_get_max_priority_wrapper .text.wifi_clock_disable_wrapper .text.wifi_clock_enable_wrapper .text.wifi_create_queue .text.wifi_create_queue_wrapper .text.wifi_delete_queue .text.wifi_delete_queue_wrapper .text.wifi_reset_mac_wrapper .text.wifi_thread_semphr_free .text.wifi_thread_semphr_get_wrapper)
 *libesp_wifi.a:wifi_netif.*(.literal.esp_wifi_create_if_driver .literal.esp_wifi_destroy_if_driver .literal.esp_wifi_get_if_mac .literal.esp_wifi_register_if_rxcb .literal.wifi_ap_receive .literal.wifi_driver_start .literal.wifi_free .literal.wifi_transmit .text .text.esp_wifi_create_if_driver .text.esp_wifi_destroy_if_driver .text.esp_wifi_get_if_mac .text.esp_wifi_is_if_ready_when_started .text.esp_wifi_register_if_rxcb .text.wifi_ap_receive .text.wifi_driver_start .text.wifi_free .text.wifi_transmit)
 *libfreertos.a:event_groups.*(.literal.vEventGroupClearBitsCallback .literal.vEventGroupDelete .literal.vEventGroupSetBitsCallback .literal.xEventGroupClearBits .literal.xEventGroupCreate .literal.xEventGroupCreateStatic .literal.xEventGroupGetStaticBuffer .literal.xEventGroupSetBits .literal.xEventGroupSync .literal.xEventGroupWaitBits .text .text.prvTestWaitCondition .text.vEventGroupClearBitsCallback .text.vEventGroupDelete .text.vEventGroupSetBitsCallback .text.xEventGroupClearBits .text.xEventGroupCreate .text.xEventGroupCreateStatic .text.xEventGroupGetStaticBuffer .text.xEventGroupSetBits .text.xEventGroupSync .text.xEventGroupWaitBits)
 *libfreertos.a:list.*(.text .text.vListInitialise .text.vListInitialiseItem .text.vListInsert)
 *libfreertos.a:port.*(.literal.pxPortInitialiseStack .literal.vApplicationStackOverflowHook .literal.vPortCleanUpCoprocArea .literal.vPortEndScheduler .literal.vPortExitCriticalCompliance .literal.vPortTCBPreDeleteHook .literal.vPortTLSPointersDelCb .literal.vPortTaskWrapper .literal.xPortEnterCriticalTimeoutCompliance .text .text.pxPortInitialiseStack .text.vApplicationStackOverflowHook .text.vPortCleanUpCoprocArea .text.vPortEndScheduler .text.vPortExitCriticalCompliance .text.vPortTCBPreDeleteHook .text.vPortTLSPointersDelCb .text.vPortTaskWrapper .text.xPortEnterCriticalTimeoutCompliance .text.xPortGetTickRateHz)
 *libfreertos.a:queue.*(.literal.prvInitialiseMutex .literal.prvInitialiseNewQueue .literal.uxQueueMessagesWaiting .literal.uxQueueSpacesAvailable .literal.vQueueDelete .literal.vQueueWaitForMessageRestricted .literal.xQueueAddToSet .literal.xQueueCreateCountingSemaphore .literal.xQueueCreateCountingSemaphoreStatic .literal.xQueueCreateMutex .literal.xQueueCreateMutexStatic .literal.xQueueCreateSet .literal.xQueueGenericCreate .literal.xQueueGenericCreateStatic .literal.xQueueGenericGetStaticBuffers .literal.xQueueGenericReset .literal.xQueueGenericSend .literal.xQueueGetMutexHolder .literal.xQueueGiveMutexRecursive .literal.xQueuePeek .literal.xQueueReceive .literal.xQueueRemoveFromSet .literal.xQueueSelectFromSet .literal.xQueueSemaphoreTake .literal.xQueueTakeMutexRecursive .text .text.prvGetDisinheritPriorityAfterTimeout .text.prvInitialiseMutex .text.prvInitialiseNewQueue .text.uxQueueMessagesWaiting .text.uxQueueSpacesAvailable .text.vQueueDelete .text.vQueueWaitForMessageRestricted .text.xQueueAddToSet .text.xQueueCreateCountingSemaphore .text.xQueueCreateCountingSemaphoreStatic .text.xQueueCreateMutex .text.xQueueCreateMutexStatic .text.xQueueCreateSet .text.xQueueGenericCreate .text.xQueueGenericCreateStatic .text.xQueueGenericGetStaticBuffers .text.xQueueGenericReset .text.xQueueGenericSend .text.xQueueGetMutexHolder .text.xQueueGiveMutexRecursive .text.xQueuePeek .text.xQueueReceive .text.xQueueRemoveFromSet .text.xQueueSelectFromSet .text.xQueueSemaphoreTake .text.xQueueTakeMutexRecursive)
 *libfreertos.a:stream_buffer.*(.literal.prvInitialiseNewStreamBuffer .literal.prvReadBytesFromBuffer .literal.prvWriteBytesToBuffer .literal.vStreamBufferDelete .literal.xStreamBufferBytesAvailable .literal.xStreamBufferGenericCreate .literal.xStreamBufferGenericCreateStatic .literal.xStreamBufferGetStaticBuffers .literal.xStreamBufferIsEmpty .literal.xStreamBufferIsFull .literal.xStreamBufferNextMessageLengthBytes .literal.xStreamBufferReceive .literal.xStreamBufferReset .literal.xStreamBufferSend .literal.xStreamBufferSetTriggerLevel .literal.xStreamBufferSpacesAvailable .text .text.prvInitialiseNewStreamBuffer .text.prvReadBytesFromBuffer .text.prvWriteBytesToBuffer .text.vStreamBufferDelete .text.xStreamBufferBytesAvailable .text.xStreamBufferGenericCreate .text.xStreamBufferGenericCreateStatic .text.xStreamBufferGetStaticBuffers .text.xStreamBufferIsEmpty .text.xStreamBufferIsFull .text.xStreamBufferNextMessageLengthBytes .text.xStreamBufferReceive .text.xStreamBufferReset .text.xStreamBufferSend .text.xStreamBufferSetTriggerLevel .text.xStreamBufferSpacesAvailable)
 *libfreertos.a:tasks.*(.literal.eTaskGetState .literal.pcTaskGetName .literal.prvAddCurrentTaskToDelayedList .literal.prvAddNewTaskToReadyList .literal.prvCheckTasksWaitingTermination .literal.prvCreateIdleTasks .literal.prvDeleteTCB .literal.prvIdleTask .literal.prvInitialiseNewTask .literal.prvInitialiseTaskLists .literal.prvReleaseKernelLock .literal.prvTakeKernelLock .literal.prvTaskPriorityRaise .literal.prvTaskPriorityRestore .literal.pvTaskGetCurrentTCBForCore .literal.pvTaskGetThreadLocalStoragePointer .literal.pvTaskIncrementMutexHeldCount .literal.pxGetTaskListByIndex .literal.pxTaskGetStackStart .literal.ulTaskGenericNotifyTake .literal.ulTaskGenericNotifyValueClear .literal.uxTaskGetNumberOfTasks .literal.uxTaskGetSnapshotAll .literal.uxTaskGetStackHighWaterMark .literal.uxTaskGetStackHighWaterMark2 .literal.uxTaskPriorityGet .literal.uxTaskResetEventItemValue .literal.vTaskDelay .literal.vTaskDelete .literal.vTaskEndScheduler .literal.vTaskInternalSetTimeOutState .literal.vTaskMissedYield .literal.vTaskPlaceOnEventList .literal.vTaskPlaceOnEventListRestricted .literal.vTaskPlaceOnUnorderedEventList .literal.vTaskPriorityDisinheritAfterTimeout .literal.vTaskPrioritySet .literal.vTaskRemoveFromUnorderedEventList .literal.vTaskResume .literal.vTaskSetThreadLocalStoragePointer .literal.vTaskSetThreadLocalStoragePointerAndDelCallback .literal.vTaskSetTimeOutState .literal.vTaskStartScheduler .literal.vTaskSuspend .literal.vTaskSuspendAll .literal.xTaskAbortDelay .literal.xTaskCatchUpTicks .literal.xTaskCheckForTimeOut .literal.xTaskCreatePinnedToCore .literal.xTaskCreateStaticPinnedToCore .literal.xTaskDelayUntil .literal.xTaskGenericNotify .literal.xTaskGenericNotifyStateClear .literal.xTaskGenericNotifyWait .literal.xTaskGetCoreID .literal.xTaskGetCurrentTaskHandle .literal.xTaskGetCurrentTaskHandleForCore .literal.xTaskGetHandle .literal.xTaskGetIdleTaskHandle .literal.xTaskGetIdleTaskHandleForCore .literal.xTaskGetNext .literal.xTaskGetStackStart .literal.xTaskGetStaticBuffers .literal.xTaskPriorityDisinherit .literal.xTaskPriorityInherit .literal.xTaskResumeAll .text .text.eTaskGetState .text.pcTaskGetName .text.prvAddCurrentTaskToDelayedList .text.prvAddNewTaskToReadyList .text.prvCheckTasksWaitingTermination .text.prvCreateIdleTasks .text.prvDeleteTCB .text.prvIdleTask .text.prvInitialiseNewTask .text.prvInitialiseTaskLists .text.prvReleaseKernelLock .text.prvSearchForNameWithinSingleList .text.prvTakeKernelLock .text.prvTaskCheckFreeStackSpace .text.prvTaskPriorityRaise .text.prvTaskPriorityRestore .text.pvTaskGetCurrentTCBForCore .text.pvTaskGetThreadLocalStoragePointer .text.pvTaskIncrementMutexHeldCount .text.pxGetTaskListByIndex .text.pxTaskGetStackStart .text.ulTaskGenericNotifyTake .text.ulTaskGenericNotifyValueClear .text.uxTaskGetNumberOfTasks .text.uxTaskGetSnapshotAll .text.uxTaskGetStackHighWaterMark .text.uxTaskGetStackHighWaterMark2 .text.uxTaskPriorityGet .text.uxTaskResetEventItemValue .text.vTaskDelay .text.vTaskDelete .text.vTaskEndScheduler .text.vTaskInternalSetTimeOutState .text.vTaskMissedYield .text.vTaskPlaceOnEventList .text.vTaskPlaceOnEventListRestricted .text.vTaskPlaceOnUnorderedEventList .text.vTaskPriorityDisinheritAfterTimeout .text.vTaskPrioritySet .text.vTaskRemoveFromUnorderedEventList .text.vTaskResume .text.vTaskSetThreadLocalStoragePointer .text.vTaskSetThreadLocalStoragePointerAndDelCallback .text.vTaskSetTimeOutState .text.vTaskStartScheduler .text.vTaskSuspend .text.vTaskSuspendAll .text.xTaskAbortDelay .text.xTaskCatchUpTicks .text.xTaskCheckForTimeOut .text.xTaskCreatePinnedToCore .text.xTaskCreateStaticPinnedToCore .text.xTaskDelayUntil .text.xTaskGenericNotify .text.xTaskGenericNotifyStateClear .text.xTaskGenericNotifyWait .text.xTaskGetCoreID .text.xTaskGetCurrentTaskHandle .text.xTaskGetCurrentTaskHandleForCore .text.xTaskGetHandle .text.xTaskGetIdleTaskHandle .text.xTaskGetIdleTaskHandleForCore .text.xTaskGetNext .text.xTaskGetStackStart .text.xTaskGetStaticBuffers .text.xTaskPriorityDisinherit .text.xTaskPriorityInherit .text.xTaskResumeAll .text.xTimerCreateTimerTask)
 *libfreertos.a:timers.*(.literal.pcTimerGetName .literal.prvCheckForValidListAndQueue .literal.prvGetNextExpireTime .literal.prvInitialiseNewTimer .literal.prvInsertTimerInActiveList .literal.prvProcessExpiredTimer .literal.prvProcessReceivedCommands .literal.prvProcessTimerOrBlockTask .literal.prvReloadTimer .literal.prvSampleTimeNow .literal.prvSwitchTimerLists .literal.prvTimerTask .literal.pvTimerGetTimerID .literal.uxTimerGetReloadMode .literal.vTimerSetReloadMode .literal.vTimerSetTimerID .literal.xTimerCreate .literal.xTimerCreateStatic .literal.xTimerCreateTimerTask .literal.xTimerGetExpiryTime .literal.xTimerGetPeriod .literal.xTimerGetReloadMode .literal.xTimerGetStaticBuffer .literal.xTimerGetTimerDaemonTaskHandle .literal.xTimerIsTimerActive .literal.xTimerPendFunctionCall .text .text.pcTimerGetName .text.prvCheckForValidListAndQueue .text.prvGetNextExpireTime .text.prvInitialiseNewTimer .text.prvInsertTimerInActiveList .text.prvProcessExpiredTimer .text.prvProcessReceivedCommands .text.prvProcessTimerOrBlockTask .text.prvReloadTimer .text.prvSampleTimeNow .text.prvSwitchTimerLists .text.prvTimerTask .text.pvTimerGetTimerID .text.uxTimerGetReloadMode .text.vTimerSetReloadMode .text.vTimerSetTimerID .text.xTimerCreate .text.xTimerCreateStatic .text.xTimerCreateTimerTask .text.xTimerGetExpiryTime .text.xTimerGetPeriod .text.xTimerGetReloadMode .text.xTimerGetStaticBuffer .text.xTimerGetTimerDaemonTaskHandle .text.xTimerIsTimerActive .text.xTimerPendFunctionCall)
 *libheap.a:multi_heap.*(.literal.multi_heap_check .literal.multi_heap_dump .literal.multi_heap_dump_tlsf .literal.multi_heap_find_containing_block_impl .literal.multi_heap_get_info_impl .literal.multi_heap_register_impl .literal.multi_heap_reset_minimum_free_bytes .literal.multi_heap_restore_minimum_free_bytes .literal.multi_heap_walk .text .text.multi_heap_check .text.multi_heap_dump .text.multi_heap_dump_tlsf .text.multi_heap_find_containing_block_impl .text.multi_heap_free_size_impl .text.multi_heap_get_info_impl .text.multi_heap_get_info_tlsf .text.multi_heap_minimum_free_size_impl .text.multi_heap_register_impl .text.multi_heap_reset_minimum_free_bytes .text.multi_heap_restore_minimum_free_bytes .text.multi_heap_walk)
 *libheap.a:tlsf.*(.literal.control_construct .literal.default_walker .literal.integrity_walker .literal.tlsf_add_pool .literal.tlsf_check .literal.tlsf_check_pool .literal.tlsf_create .literal.tlsf_create_with_pool .literal.tlsf_fit_size .literal.tlsf_malloc_addr .literal.tlsf_remove_pool .literal.tlsf_walk_pool .text .text.control_construct .text.default_walker .text.integrity_walker .text.tlsf_add_pool .text.tlsf_check .text.tlsf_check_pool .text.tlsf_create .text.tlsf_create_with_pool .text.tlsf_destroy .text.tlsf_find_containing_block .text.tlsf_fit_size .text.tlsf_malloc_addr .text.tlsf_pool_overhead .text.tlsf_remove_pool .text.tlsf_walk_pool)
 *liblog.a:log_timestamp.*(.text)
 *liblog.a:log_write.*(.literal.esp_log_set_vprintf .text .text.esp_log_set_vprintf)
 *liblog.a:tag_log_level.*(.literal.esp_log_level_get .literal.esp_log_level_set .literal.log_level_get .literal.log_level_set .text .text.esp_log_level_get .text.esp_log_level_set .text.log_level_get .text.log_level_set)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_app_disable_protect .literal.esp_flash_get_protectable_regions .literal.esp_flash_read_chip_id .literal.esp_flash_read_id .literal.esp_flash_read_unique_chip_id .literal.esp_flash_suspend_cmd_init .literal.find_region .text .text.esp_flash_app_disable_protect .text.esp_flash_get_protectable_regions .text.esp_flash_read_chip_id .text.esp_flash_read_id .text.esp_flash_read_unique_chip_id .text.esp_flash_suspend_cmd_init .text.find_region)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.esp_flash_app_enable_os_functions .literal.esp_flash_deinit_os_functions .literal.esp_flash_init_os_functions .text .text.esp_flash_app_enable_os_functions .text.esp_flash_deinit_os_functions .text.esp_flash_init_main_bus_lock .text.esp_flash_init_os_functions .text.esp_flash_set_dangerous_write_protection .text.use_bus_lock)
 *libspi_flash.a:spi_flash_os_func_noos.*(.text)
 *libxtensa.a:xt_trax.*(.literal .literal.* .text .text.*)
 *libxtensa.a:xtensa_intr.*(.literal .literal.* .text .text.*)

    *(.stub)
    *(.gnu.warning)
    *(.gnu.linkonce.literal.* .gnu.linkonce.t.*.literal .gnu.linkonce.t.*)
    *(.irom0.text) /* catch stray ICACHE_RODATA_ATTR */
    /**
     * CPU will try to prefetch up to 16 bytes of of instructions.
     * This means that any configuration (e.g. MMU, PMS) must allow
     * safe access to up to 16 bytes after the last real instruction, add
     * dummy bytes to ensure this
     */
    . += 16;
    _text_end = ABSOLUTE(.);
    /**
     * Mark the flash.text end.
     * This can be used for MMU driver to maintain virtual address.
     */
    _instruction_reserved_end = ABSOLUTE(.);
    _etext = .;
    /**
     * Similar to _iram_start, this symbol goes here so it is
     * resolved by addr2line in preference to the first symbol in
     * the flash.text segment.
     */
    _flash_cache_start = ABSOLUTE(0);
  } > default_code_seg
  /**
   * Dummy section represents the .flash.text section but in default_rodata_seg.
   * Thus, it must have its alignment and (at least) its size.
   */
  .flash_rodata_dummy (NOLOAD):
  {
    _flash_rodata_dummy_start = ABSOLUTE(.);
    . = ALIGN(ALIGNOF(.flash.text)) + SIZEOF(.flash.text);
    /* Add alignment of MMU page size + 0x20 bytes for the mapping header. */
    . = ALIGN(0x10000) + 0x20;
  } > default_rodata_seg
  .flash.appdesc : ALIGN(0x10)
  {
    /**
     * Mark flash.rodata start.
     * This can be used for mmu driver to maintain virtual address
     */
    _rodata_reserved_start = ABSOLUTE(.);
    _rodata_start = ABSOLUTE(.);
    /* !DO NOT PUT ANYTHING BEFORE THIS! */
    /* Should be the first.  App version info. */
    *(.rodata_desc .rodata_desc.*)
    /* Should be the second. Custom app version info. */
    *(.rodata_custom_desc .rodata_custom_desc.*)
    /**
     * Create an empty gap within this section. Thanks to this, the end of this
     * section will match .flah.rodata's begin address. Thus, both sections
     * will be merged when creating the final bin image.
     */
    . = ALIGN(ALIGNOF(.flash.rodata));
  } > default_rodata_seg
  ASSERT((ADDR(.flash.rodata) == ADDR(.flash.appdesc) + SIZEOF(.flash.appdesc)), "The gap between .flash.appdesc and .flash.rodata must not exist to produce the final bin image.")
  .flash.rodata : ALIGN(0x10)
  {
    _flash_rodata_start = ABSOLUTE(.);
    
 
 _esp_trace_encoder_array_start = ABSOLUTE(.);
 KEEP(*(SORT_BY_NAME(.esp_trace_encoder_desc)))
 _esp_trace_encoder_array_end = ABSOLUTE(.);
 _esp_trace_transport_array_start = ABSOLUTE(.);
 KEEP(*(SORT_BY_NAME(.esp_trace_transport_desc)))
 _esp_trace_transport_array_end = ABSOLUTE(.);
 *(EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .rodata EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .rodata.* EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .sdata2 EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .sdata2.* EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .srodata EXCLUDE_FILE(*libesp_hal_regi2c.a *libesp_hal_systimer.a *libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_i2c.a:i2c_hal_iram.* *libesp_hal_ledc.a:ledc_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .srodata.*)
 *(.rodata_wlog_error .rodata_wlog_error.*)
 *(.rodata_wlog_info .rodata_wlog_info.*)
 *(.rodata_wlog_warning .rodata_wlog_warning.*)
 *libesp_driver_dma.a:gdma_link.*(.rodata.__FUNCTION__$0 .rodata.__FUNCTION__$1 .rodata.__FUNCTION__$2 .rodata.gdma_new_link_list.str1.4)
 *libesp_driver_rmt.a:rmt_tx.*(.rodata.__FUNCTION__$0 .rodata.__FUNCTION__$10 .rodata.__FUNCTION__$12 .rodata.__FUNCTION__$13 .rodata.__FUNCTION__$14 .rodata.__FUNCTION__$15 .rodata.__FUNCTION__$19 .rodata.__FUNCTION__$21 .rodata.__FUNCTION__$22 .rodata.__FUNCTION__$3 .rodata.__FUNCTION__$4 .rodata.__FUNCTION__$5 .rodata.__FUNCTION__$6 .rodata.__FUNCTION__$7 .rodata.__FUNCTION__$9 .rodata.__func__$1 .rodata.__func__$11 .rodata.__func__$16 .rodata.__func__$17 .rodata.__func__$18 .rodata.__func__$2 .rodata.__func__$20 .rodata.__func__$8 .rodata.rmt_del_tx_channel.str1.4 .rodata.rmt_ll_tx_enable_dma.str1.4 .rodata.rmt_ll_tx_set_carrier_high_low_ticks.str1.4 .rodata.rmt_new_sync_manager.str1.4 .rodata.rmt_new_tx_channel.str1.4 .rodata.rmt_transmit.str1.4 .rodata.rmt_tx_create_trans_queue.str1.4 .rodata.rmt_tx_destroy.str1.4 .rodata.rmt_tx_disable.str1.4 .rodata.rmt_tx_enable.str1.4 .rodata.rmt_tx_init_dma_link.str1.4 .rodata.rmt_tx_register_event_callbacks.str1.4 .rodata.rmt_tx_register_to_group.str1.4 .rodata.rmt_tx_switch_gpio.str1.4 .rodata.rmt_tx_wait_all_done.str1.4)
 *libesp_hw_support.a:cpu.*(.rodata.__func__$0 .rodata.__func__$1 .rodata.__func__$2)
 *libesp_system.a:reset_reason.*(.rodata.__func__$0)
 *libheap.a:multi_heap.*(.rodata.__func__$0 .rodata.__func__$1 .rodata.__func__$2 .rodata.__func__$3 .rodata.__func__$4 .rodata.__func__$5 .rodata.__func__$6 .rodata.__func__$7 .rodata.__func__$8 .rodata.multi_heap_dump.str1.4 .rodata.multi_heap_dump_tlsf.str1.4 .rodata.multi_heap_find_containing_block_impl.str1.4 .rodata.multi_heap_register_impl.str1.4)
 *libheap.a:tlsf.*(.rodata.__func__$0 .rodata.__func__$1 .rodata.__func__$10 .rodata.__func__$11 .rodata.__func__$12 .rodata.__func__$13 .rodata.__func__$14 .rodata.__func__$15 .rodata.__func__$16 .rodata.__func__$17 .rodata.__func__$19 .rodata.__func__$2 .rodata.__func__$20 .rodata.__func__$3 .rodata.__func__$5 .rodata.__func__$6 .rodata.__func__$7 .rodata.__func__$8 .rodata.__func__$9 .rodata.control_construct.str1.4 .rodata.default_walker.str1.4 .rodata.tlsf_add_pool.str1.4 .rodata.tlsf_check.str1.4 .rodata.tlsf_create.str1.4 .rodata.tlsf_remove_pool.str1.4)
 *libspi_flash.a:spi_flash_os_func_app.*(.rodata.__func__$0 .rodata.esp_flash_spi23_default_os_functions)

    *(.irom1.text) /* catch stray ICACHE_RODATA_ATTR */
    *(.gnu.linkonce.r.*)
    *(.rodata1)
    /* C++ exception handlers table. */
    
 . = ALIGN(4); 
 __XT_EXCEPTION_TABLE_ = ABSOLUTE(.);
    *(.xt_except_table)
    *(.gcc_except_table .gcc_except_table.*)
    *(.gnu.linkonce.e.*)
    
 . = ALIGN(4); 
 __XT_EXCEPTION_DESCS_ = ABSOLUTE(.);
    *(.xt_except_desc)
    *(.gnu.linkonce.h.*)
    __XT_EXCEPTION_DESCS_END__ = ABSOLUTE(.);
    *(.xt_except_desc_end)
    /**
     * C++ constructor tables.
     *
     * Excluding crtbegin.o/crtend.o since IDF doesn't use the toolchain crt.
     */
    
 . = ALIGN(4); 
 __preinit_array_start = ABSOLUTE(.);
    
 . = ALIGN(4); 
 __bothinit_array_start = ABSOLUTE(.);
    KEEP (*(.preinit_array))
    __preinit_array_end = ABSOLUTE(.);
    
 . = ALIGN(4); 
 __init_array_start = ABSOLUTE(.);
    KEEP (*(SORT_BY_INIT_PRIORITY(EXCLUDE_FILE (*crtend.* *crtbegin.*) .ctors.*)))
    KEEP (*(EXCLUDE_FILE (*crtend.* *crtbegin.*) .ctors))
    __init_array_end = ABSOLUTE(.);
    __bothinit_array_end = ABSOLUTE(.);
    /* Addresses of memory regions reserved via SOC_RESERVE_MEMORY_REGION() */
    
 . = ALIGN(4); 
 soc_reserved_memory_region_start = ABSOLUTE(.);
    KEEP (*(.reserved_memory_address))
    soc_reserved_memory_region_end = ABSOLUTE(.);
    /* System init functions registered via ESP_SYSTEM_INIT_FN */
    
 . = ALIGN(4); 
 _esp_system_init_fn_array_start = ABSOLUTE(.);
    KEEP (*(SORT_BY_INIT_PRIORITY(.esp_system_init_fn.*)))
    _esp_system_init_fn_array_end = ABSOLUTE(.);
    _rodata_end = ABSOLUTE(.);
    /* Literals are also RO data. */
    _lit4_start = ABSOLUTE(.);
    *(*.lit4)
    *(.lit4.*)
    *(.gnu.linkonce.lit4.*)
    _lit4_end = ABSOLUTE(.);
    . = ALIGN(ALIGNOF(.flash.tdata));
  } > default_rodata_seg
  ASSERT((ADDR(.flash.tdata) == ADDR(.flash.rodata) + SIZEOF(.flash.rodata)), "The gap between .flash.rodata and .flash.tdata must not exist to produce the final bin image.")
  .flash.tdata :
  {
    /* Keep tdata and tbss sections contiguous (no gaps between them).
     * The TLS runtime code calculates offsets assuming these sections are
     * adjacent. Gaps would cause incorrect address calculations, leading
     * to accessing wrong memory.
     */
    /* tdata sections */
    _thread_local_data_start = ABSOLUTE(.);
    _picolibc_reent_stub_start = ABSOLUTE(.);
    KEEP(*(.tdata.errno))
    /* Reproduce the public fields from struct _reent. */
    KEEP(*(.tdata.tls_stdin))
    KEEP(*(.tdata.tls_stdout))
    KEEP(*(.tdata.tls_stderr))
    _picolibc_reent_stub_end = ABSOLUTE(.);
    *(.tdata .tdata.* .gnu.linkonce.td.*)
    _thread_local_data_end = ABSOLUTE(.);
    /* tbss sections */
    _thread_local_bss_start = ABSOLUTE(.);
    *(.tbss .tbss.* .gnu.linkonce.tb.*)
    *(.tcommon .tcommon.*)
    _thread_local_bss_end = ABSOLUTE(.);
  } > default_rodata_seg
  _tls_section_alignment = ALIGNOF(.flash.tdata);
  ASSERT((_picolibc_reent_stub_end - _picolibc_reent_stub_start) == 16, "Newlib _reent stub have wrong size")
  ASSERT(_thread_local_data_end == _thread_local_bss_start,
         "tdata and tbss must be contiguous.")
  /**
   * This section contains all the rodata that is not used
   * at runtime, helping to avoid an increase in binary size.
   */
  .flash.rodata_noload (NOLOAD) :
  {
    /**
     * This symbol marks the end of flash.rodata. It can be utilized by the MMU
     * driver to maintain the virtual address.
     * NOLOAD rodata may not be included in this section.
     */
    _rodata_reserved_end = ABSOLUTE(.);
    
 *(.rodata_wlog_debug .rodata_wlog_debug.*)
 *(.rodata_wlog_verbose .rodata_wlog_verbose.*)
  } > default_rodata_seg
  /**
   * Dummy section to skip flash rodata sections.
   * Because to `extern_ram_seg` and `drom0_0_seg` are on the same bus
   */
  .ext_ram.dummy (NOLOAD):
  {
    . = ORIGIN(extern_ram_seg);
    . = . + (_rodata_reserved_end - _flash_rodata_dummy_start);
    . = ALIGN (0x10000);
  } > extern_ram_seg
  /* Marks the end of IRAM code segment */
  .iram0.text_end (NOLOAD) :
  {
    /* Padding for possible CPU prefetch + alignment for PMS split lines */
    . += 16;
    . = ALIGN(256);
    /* iram_end_test section exists for use by memprot unit tests only */
    *(.iram_end_test)
    _iram_text_end = ABSOLUTE(.);
  } > iram0_0_seg
  .iram0.data :
  {
    
 . = ALIGN(4); 
 _iram_data_start = ABSOLUTE(.);
    
 *(.iram.data .iram.data.*)
    
 . = ALIGN(4); 
 _iram_data_end = ABSOLUTE(.);
  } > iram0_0_seg
  .iram0.bss (NOLOAD) :
  {
    
 . = ALIGN(4); 
 _iram_bss_start = ABSOLUTE(.);
    
 *(.iram.bss .iram.bss.*)
    _iram_bss_end = ABSOLUTE(.);
    
 . = ALIGN(4); 
 _iram_end = ABSOLUTE(.);
  } > iram0_0_seg
  /* Marks the end of data, bss and possibly rodata  */
  .dram0.heap_start (NOLOAD) :
  {
    /* Lowest possible start address for the heap */
    
 . = ALIGN(8); 
 _heap_low_start = ABSOLUTE(.);
  } > dram0_0_seg
/*
 * SPDX-FileCopyrightText: 2021-2024 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/* CPU instruction prefetch padding size for flash mmap scenario */
/* Copy from esp_secure_boot.h */
/*
 * PMP region granularity size
 * Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones
 * to pmpaddr0, then reading back pmpaddr0. If G is the index of the least-significant bit set,
 * the PMP granularity is 2^G+2 bytes.
 */
/* CPU instruction prefetch padding size for memory protection scenario */
/* Memory alignment size for PMS */
    /* rtc timer data (s_rtc_timer_retain_mem, see esp_clk.c files). For rtc_timer_data_in_rtc_mem section. */
/*
 * FAST_REFLASHING_PADDING
 *
 * Aligns the current location (.) to CONFIG_ESPTOOLPY_FAST_REFLASHING_PADDING.
 * If more than half of the alignment block is already consumed,
 * extra padding is applied to skip to the next boundary.
 * For example, if the current location (.) is 0x1900 and the padding is 4 KB,
 * the location will be moved to 0x3000 instead of 0x2000 because less than
 * half of the current 4 KB block remains (0x2000 - 0x1900 < 2 KB).
 */
  /**
   * This section is not included in the binary image; it is only present in the ELF file.
   * It is used to keep certain symbols in the ELF file.
   */
  .noload 0 (INFO) :
  {
    /* Reserve first 4 bytes as zero for vars pointed to NULL */
    . = 0;
    LONG(0);
    _noload_keep_in_elf_start = ABSOLUTE(.);
    
    KEEP(*(.noload_keep_in_elf .noload_keep_in_elf.*))
    _noload_keep_in_elf_end = ABSOLUTE(.);
  }
  /* DWARF 1 */
  .debug 0 : { *(.debug) }
  .line 0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo 0 : { *(.debug_srcinfo) }
  .debug_sfnames 0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges 0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev 0 : { *(.debug_abbrev) }
  .debug_line 0 : { *(.debug_line) }
  .debug_frame 0 : { *(.debug_frame) }
  .debug_str 0 : { *(.debug_str) }
  .debug_loc 0 : { *(.debug_loc) }
  .debug_macinfo 0 : { *(.debug_macinfo) }
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  /* DWARF 3 */
  .debug_ranges 0 : { *(.debug_ranges) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames 0 : { *(.debug_varnames) }
  /* GNU DWARF 2 extensions */
  .debug_gnu_pubnames 0 : { *(.debug_gnu_pubnames) }
  .debug_gnu_pubtypes 0 : { *(.debug_gnu_pubtypes) }
  /* DWARF 4 */
  .debug_types 0 : { *(.debug_types) }
  /* DWARF 5 */
  .debug_addr 0 : { *(.debug_addr) }
  .debug_line_str 0 : { *(.debug_line_str) }
  .debug_loclists 0 : { *(.debug_loclists) }
  .debug_macro 0 : { *(.debug_macro) }
  .debug_names 0 : { *(.debug_names) }
  .debug_rnglists 0 : { *(.debug_rnglists) }
  .debug_str_offsets 0 : { *(.debug_str_offsets) }
  /**
   * Miscellaneous sections
   */
  .comment 0 : { *(.comment) }
  .note.GNU-stack 0 : { *(.note.GNU-stack) }
  .riscv.attributes 0 : { *(.riscv.attributes) }
/**
 * .xt.prop and .xt.lit sections will be used by the debugger and disassembler
 * to get more information about raw data present in the code.
 * Indeed, it may be required to add some padding at some points in the code
 * in order to align a branch/jump destination on a particular bound.
 * Padding these instructions will generate null bytes that shall be
 * interpreted as data, and not code by the debugger or disassembler.
 * This section will only be present in the ELF file, not in the final binary
 * For more details, check GCC-212
 */
  .xtensa.info 0 : { *(.xtensa.info) }
  .xt.prop 0 : { *(.xt.prop .xt.prop.* .gnu.linkonce.prop.*) }
  .xt.lit 0 : { *(.xt.lit .xt.lit.* .gnu.linkonce.p.*) }
/*
 * SPDX-FileCopyrightText: 2021-2024 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/* CPU instruction prefetch padding size for flash mmap scenario */
/* Copy from esp_secure_boot.h */
/*
 * PMP region granularity size
 * Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones
 * to pmpaddr0, then reading back pmpaddr0. If G is the index of the least-significant bit set,
 * the PMP granularity is 2^G+2 bytes.
 */
/* CPU instruction prefetch padding size for memory protection scenario */
/* Memory alignment size for PMS */
    /* rtc timer data (s_rtc_timer_retain_mem, see esp_clk.c files). For rtc_timer_data_in_rtc_mem section. */
/*
 * FAST_REFLASHING_PADDING
 *
 * Aligns the current location (.) to CONFIG_ESPTOOLPY_FAST_REFLASHING_PADDING.
 * If more than half of the alignment block is already consumed,
 * extra padding is applied to skip to the next boundary.
 * For example, if the current location (.) is 0x1900 and the padding is 4 KB,
 * the location will be moved to 0x3000 instead of 0x2000 because less than
 * half of the current 4 KB block remains (0x2000 - 0x1900 < 2 KB).
 */
  /DISCARD/ :
  {
   /**
    * Discarding .rela.* sections results in the following mapping:
    * .rela.text.* -> .text.*
    * .rela.data.* -> .data.*
    * And so forth...
    */
   *(.rela.*)
   *(.fini)
   *(.eh_frame_hdr)
   *(.eh_frame_hdr)
   *(.eh_frame)
  }
}
ASSERT(((_iram_end - ORIGIN(iram0_0_seg)) <= LENGTH(iram0_0_seg)),
          "IRAM0 segment data does not fit.")
ASSERT(((_heap_low_start - ORIGIN(dram0_0_seg)) <= LENGTH(dram0_0_seg)),
          "DRAM segment data does not fit.")
