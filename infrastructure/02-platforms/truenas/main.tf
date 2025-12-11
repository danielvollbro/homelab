/*
  Notice: The module has a lot of configuration, this VM I created 2020 and has
  been manually managed since, the current version of the provider want to make
  a lot of changes that I don't feel comfortable right now.

  The plan for this NAS is to make it a stand alone machine that is not
  virtualize so I just let it run as is until then.
*/

module "truenas_vm" {
  source = "../../modules/platform/truenas"
}
