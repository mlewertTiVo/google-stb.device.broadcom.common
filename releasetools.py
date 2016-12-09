import struct
import common

# add gpt update to recovery ota package: True or False
# True:
#   gpt will be added to the OTA pacakge
#   a two step update will carry out
#     1. package will update all partition and gpt table
#     2. system will reboot back into recovery to perform a format on userdata partition
# False:
#   gpt will NOT be part of the OTA package
#   Normal update will carry out.
update_gpt = False

def WriteBoltBsu(info, bolt_img, bsu_img):
  common.ZipWriteStr(info.output_zip, "bolt-bb.bin", bolt_img)
  common.ZipWriteStr(info.output_zip, "android_bsu.elf", bsu_img)

  info.script.Print("Writing bolt ...")
  info.script.AppendExtra('package_extract_file("bolt-bb.bin", "/tmp/bolt-bb.bin");')
  info.script.AppendExtra("""ext.flash_bolt("/tmp/bolt-bb.bin");""")

  info.script.Print("Writing android bsu ...")
  info.script.WriteRawImage("/bsu", "android_bsu.elf")

def WriteGPT(info, gpt_img):
  common.ZipWriteStr(info.output_zip, "gpt.bin", gpt_img)

  _, misc_device = common.GetTypeAndDevice("/misc", info.info_dict)

  info.script.Print("Write gpt ...")
  info.script.AppendExtra('package_extract_file("gpt.bin", "/tmp/gpt.bin");')
  info.script.AppendExtra("""ext.flash_gpt("/tmp/gpt.bin");""")


def FullOTA_InstallBegin(info):
  if (update_gpt):
    _, misc_device = common.GetTypeAndDevice("/misc", info.info_dict)
    bcb_dev = {"bcb_dev": misc_device}

    info.script.AppendExtra("""
if get_stage("%(bcb_dev)s") == "2/3" then
""" % bcb_dev)
    info.script.WriteRawImage("/recovery", "recovery.img")

    try:
      gpt_img = info.input_zip.read("RADIO/gpt.bin")
    except KeyError:
      print "no gpt.bin in target_files; skipping install"
    else:
      WriteGPT(info, gpt_img)

    info.script.AppendExtra("""
set_stage("%(bcb_dev)s", "3/3");
reboot_now("%(bcb_dev)s", "recovery");
else if get_stage("%(bcb_dev)s") == "3/3" then
""" % bcb_dev)

def FullOTA_InstallEnd(info):
  if (update_gpt):
    _, misc_device = common.GetTypeAndDevice("/misc", info.info_dict)
    bcb_dev = {"bcb_dev": misc_device}

    info.script.FormatPartition("/data")

    info.script.AppendExtra("""
set_stage("%(bcb_dev)s", "");
else
""" % bcb_dev)

    recovery_img = common.GetBootableImage("recovery.img", "recovery.img",
                                             common.OPTIONS.input_tmp, "RECOVERY")
    common.ZipWriteStr(info.output_zip, "recovery.img", recovery_img.data)
    info.script.WriteRawImage("/boot", "recovery.img")

  try:
    bolt_img = info.input_zip.read("RADIO/bolt-bb.bin")
    bsu_img = info.input_zip.read("RADIO/android_bsu.elf")
  except KeyError:
    print "no bolt-bb.bin or android_bsu.elf in target_files; skipping install"
  else:
    WriteBoltBsu(info, bolt_img, bsu_img)

  if (update_gpt):
    info.script.AppendExtra("""
set_stage("%(bcb_dev)s", "2/3");
reboot_now("%(bcb_dev)s", "");
endif;
endif;
""" % bcb_dev)

def IncrementalOTA_InstallBegin(info):
  if (update_gpt):
    _, misc_device = common.GetTypeAndDevice("/misc", info.info_dict)
    bcb_dev = {"bcb_dev": misc_device}

    info.script.AppendExtra("""
if get_stage("%(bcb_dev)s") == "2/3" then
""" % bcb_dev)
    info.script.WriteRawImage("/recovery", "recovery.img")

    try:
      target_gpt_img = info.target_zip.read("RADIO/gpt.bin")
      try:
        source_gpt_img = info.source_zip.read("RADIO/gpt.bin")
      except KeyError:
        target_gpt_img = None
        source_gpt_img = None

      if (target_gpt_img == source_gpt_img):
        print "gpt did not change: skipping"
      else:
        WriteGPT(info, target_gpt_img)

    except KeyError:
      print "gpt found in target_files; skipping install"

    info.script.AppendExtra("""
set_stage("%(bcb_dev)s", "3/3");
reboot_now("%(bcb_dev)s", "recovery");
else if get_stage("%(bcb_dev)s") == "3/3" then
""" % bcb_dev)


def IncrementalOTA_InstallEnd(info):
  if (update_gpt):
    _, misc_device = common.GetTypeAndDevice("/misc", info.info_dict)
    bcb_dev = {"bcb_dev": misc_device}

    info.script.FormatPartition("/data")

    info.script.AppendExtra("""
set_stage("%(bcb_dev)s", "");
""" % bcb_dev)
    info.script.AppendExtra("else\n")

    recovery_img = common.GetBootableImage("recovery.img", "recovery.img",
                                             common.OPTIONS.input_tmp, "RECOVERY")
    common.ZipWriteStr(info.output_zip, "recovery.img", recovery_img.data)
    info.script.WriteRawImage("/boot", "recovery.img")

  try:
    target_bolt_img = info.target_zip.read("RADIO/bolt-bb.bin")
    target_bsu_img = info.target_zip.read("RADIO/android_bsu.elf")
    try:
      source_bolt_img = info.source_zip.read("RADIO/bolt-bb.bin")
      source_bsu_img = info.source_zip.read("RADIO/android_bsu.elf")
    except KeyError:
      source_bolt_img = None
      source_bsu_img = None

    if (target_bolt_img == source_bolt_img and target_bsu_img == source_bsu_img):
      print "bolt and bsu unchanged; skipping"
    else:
      WriteBoltBsu(info, target_bolt_img, target_bsu_img)

  except KeyError:
    print "No bolt or bsu found in target_files; skipping install"

  if (update_gpt):
    _, misc_device = common.GetTypeAndDevice("/misc", info.info_dict)
    bcb_dev = {"bcb_dev": misc_device}

    try:
      target_gpt_img = info.target_zip.read("RADIO/gpt.bin")
      try:
        source_gpt_img = info.source_zip.read("RADIO/gpt.bin")
      except KeyError:
        target_gpt_img = None
        source_gpt_img = None

      if (target_gpt_img == source_gpt_img):
        print "gpt did not change: skipping"
      else:
        WriteGPT(info, target_gpt_img)

    except KeyError:
      print "gpt found in target_files; skipping install"

    info.script.AppendExtra("""
set_stage("%(bcb_dev)s", "2/3");
reboot_now("%(bcb_dev)s", "");
endif;
endif;
""" % bcb_dev)
