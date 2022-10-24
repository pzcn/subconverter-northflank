<template>
  <div>
    <el-row style="margin-top: 10px">
      <el-col>
        <el-card>
          <div slot="header">
          <svg-icon class="tg" icon-class="telegram" style="float:left;margin-left:8px" @click="gotoTgChannel" />
          <div style="display: inline-block; position:absolute; right: 8px;font-size:10px">{{ backendVersion }}</div>
          <div style="text-align:center;font-size:15px">在线订阅转换</div>
          </div>
          
          <el-container>
            <el-form :model="form" label-width="80px" label-position="left" style="width: 100%">
              <el-form-item label="订阅链接:">
                <el-input
                  v-model="form.sourceSubUrl"
                  type="textarea"
                  rows="3"
                  placeholder="支持各种订阅链接或单节点链接，多个链接每行一个或用 | 分隔"
                />
              </el-form-item>

                
                <el-form-item label-width="0px">
                 <el-collapse>
                    <el-collapse-item>
                    <template slot="title">
                    <el-form-item label="高级功能:" style="width: 100%;">
                     <el-button
                      type="limr"
                      style="width: 100%;"
                      icon="el-icon-more-outline"
                     >点击显示/隐藏</el-button>
                    </el-form-item>    
                    </template>
                    <el-form-item label="订阅类型:">
                     <el-select v-model="form.clientType" style="width: 100%">
                     <el-option v-for="(v, k) in options.clientTypes" :key="k" :label="k" :value="v"></el-option>
                    </el-select>
                    </el-form-item>
                     <el-form-item label="短链选择:">
                   <el-select 
                  v-model="form.shortType" 
                  allow-create
                  filterable
                  placeholder="可输入其他可用短链API"
                  style="width: 100%"
                >
                  <el-option v-for="(v, k) in options.shortTypes" :key="k" :label="k" :value="v"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="远程配置:">
                  <el-select
                    v-model="form.remoteConfig"
                    allow-create
                    filterable
                    placeholder="请选择"
                    style="width: 100%"
                  >
                    <el-option-group
                      v-for="group in options.remoteConfig"
                      :key="group.label"
                      :label="group.label"
                    >
                      <el-option
                        v-for="item in group.options"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                      ></el-option>
                    </el-option-group>
                    <el-button slot="append" @click="gotoRemoteConfig" icon="el-icon-link">配置示例</el-button>
                  </el-select>
                </el-form-item>
                    <el-form-item label="包含节点:">
                    <el-input v-model="form.includeRemarks" placeholder="要保留的节点，支持正则" />
                    </el-form-item>
                    <el-form-item label="排除节点:">
                    <el-input v-model="form.excludeRemarks" placeholder="要排除的节点，支持正则" />
                    </el-form-item>
					<el-form-item label="节点命名:">
					<el-input v-model="form.rename" placeholder="举例：`香港@菲律宾``美国@巴西``台湾@俄罗斯`..." />
					</el-form-item>
					<el-form-item label="订阅命名:">
                    <el-input v-model="form.filename" placeholder="返回的订阅文件名" />
                    </el-form-item>
                <el-form-item label-width="0px">
                  <el-row type="flex">
                    <el-col>
                      <el-checkbox class="nodeinfo" v-model="form.nodeList" label="仅输出节点信息" border></el-checkbox>
                    </el-col>
                      <el-popover placement="bottom" v-model="form.extraset">
                      <el-row :gutter="10">
                        <el-col :span="12"><el-checkbox v-model="form.emoji" label="Emoji"></el-checkbox></el-col>
                        <el-col :span="12"><el-checkbox v-model="form.insert" label="网易云"></el-checkbox></el-col>
                      </el-row>
                      <el-row :gutter="10">
                        <el-col :span="12"><el-checkbox v-model="form.udp" label="启用 UDP"></el-checkbox></el-col>
                        <el-col :span="12"><el-checkbox v-model="form.sort" label="排序节点"></el-checkbox></el-col>          
                      </el-row>    
                      <el-row :gutter="10">
                        <el-col :span="12"><el-checkbox v-model="form.tfo" label="启用 TFO"></el-checkbox></el-col>
                        <el-col :span="12"><el-checkbox v-model="form.tpl.surge.doh" label="Surge.DoH"></el-checkbox></el-col>
                      </el-row>
                      <el-row :gutter="10">
                        <el-col :span="12"><el-checkbox v-model="form.appendType" label="插入节点类型"></el-checkbox></el-col>
                        <el-col :span="12"><el-checkbox v-model="form.tpl.clash.doh" label="Clash.DoH"></el-checkbox></el-col>                        
                      </el-row>
                      <el-row :gutter="10">
                        <el-col :span="12"><el-checkbox v-model="form.expand" label="展开规则全文"></el-checkbox></el-col>
                        <el-col :span="12"><el-checkbox v-model="form.new_name" label="Clash新字段名"></el-checkbox></el-col>
                      </el-row>
                      <el-row :gutter="10">
                        <el-col :span="12"><el-checkbox v-model="form.scv" label="跳过证书验证"></el-checkbox></el-col>
                        <el-col :span="12"><el-checkbox v-model="form.fdn" label="过滤不支持节点"></el-checkbox></el-col>
                      </el-row>
                      <el-button slot="reference">更多选项</el-button>
                    </el-popover>
                  </el-row>
                </el-form-item>    
                </el-collapse-item>
                </el-collapse>
                </el-form-item>

              <div style="margin-top: 30px"></div>

              <el-divider content-position="center">
                <el-button 
                 type="zhuti"
                 @click="change">
                 <i id="rijian" class="el-icon-sunny" ></i>  
                 <i id="yejian" class="el-icon-moon" ></i>    
                 </el-button>
              </el-divider>

              <el-form-item label="定制订阅:">
                <el-input class="copy-content" disabled v-model="customSubUrl">
                  <el-button
                    slot="append"
                    v-clipboard:copy="customSubUrl"
                    v-clipboard:success="onCopy"
                    ref="copy-btn"
                    icon="el-icon-document-copy"
                  >复制</el-button>
                </el-input>
              </el-form-item>
              <el-form-item label="订阅短链:">
                <el-input class="copy-content" disabled v-model="curtomShortSubUrl">
                  <el-button
                    slot="append"
                    v-clipboard:copy="curtomShortSubUrl"
                    v-clipboard:success="onCopy"
                    ref="copy-btn"
                    icon="el-icon-document-copy"
                  >复制</el-button>
                </el-input>
              </el-form-item>

              <el-form-item label-width="0px" style="margin-top: 40px; text-align: center">
                <el-button
                  style="width: 120px"
                  type="danger"
                  @click="makeUrl"
                  :disabled="form.sourceSubUrl.length === 0"
                  icon="el-icon-magic-stick"
                >生成订阅链接</el-button>
                <el-button
                  style="width: 120px"
                  type="danger"
                  @click="makeShortUrl"
                  :loading="loading"
                  icon="el-icon-link"
                  :disabled="customSubUrl.length === 0"
                >生成短链接</el-button>
                </el-form-item>
                
              <el-form-item label-width="0px" style="text-align: center">
                <!-- <el-button style="width: 120px" type="primary" @click="surgeInstall" icon="el-icon-connection">一键导入Surge</el-button> -->
                <el-button
                  style="width: 120px"
                  type="primary"
                  @click="clashInstall"
                  icon="el-icon-connection"
                  :disabled="customSubUrl.length === 0"
                >一键导入Clash</el-button>
				</el-form-item>
				<el-form-item label-width="0px" style="text-align: center">
              </el-form-item>
            </el-form>
          </el-container>
        </el-card>
      </el-col>
    </el-row>

    <el-dialog
      :visible.sync="dialogUploadConfigVisible"
      :show-close="false"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      width="80%"
    >
      <div slot="title">
        Remote config upload
        <el-popover trigger="hover" placement="right" style="margin-left: 10px">
          <el-link type="primary" :href="sampleConfig" target="_blank" icon="el-icon-info">参考配置</el-link>
          <i class="el-icon-question" slot="reference"></i>
        </el-popover>
      </div>
      <el-form label-position="left">
        <el-form-item prop="uploadConfig">
          <el-input
            v-model="uploadConfig"
            type="textarea"
            :autosize="{ minRows: 15, maxRows: 15}"
            maxlength="10000"
            show-word-limit
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="uploadConfig = ''; dialogUploadConfigVisible = false">取 消</el-button>
        <el-button
          type="primary"
          @click="confirmUploadConfig"
          :disabled="uploadConfig.length === 0"
        >确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
const project = process.env.VUE_APP_PROJECT
const remoteConfigSample = process.env.VUE_APP_SUBCONVERTER_REMOTE_CONFIG
const gayhubRelease = process.env.VUE_APP_BACKEND_RELEASE
const defaultBackend = process.env.VUE_APP_SUBCONVERTER_DEFAULT_BACKEND + '/sub?'
const shortUrlBackend = process.env.VUE_APP_MYURLS_DEFAULT_BACKEND + '/short'
const configUploadBackend = process.env.VUE_APP_CONFIG_UPLOAD_BACKEND + '/config/upload'
const tgBotLink = process.env.VUE_APP_BOT_LINK

export default {
  data() {
    return {
      backendVersion: "",
      advanced: "2",

      // 是否为 PC 端
      isPC: true,

      options: {
        clientTypes: {
          地区分组: "api",
          极简: "min",
          自动: "auto",
          混合订阅: "mixed",
          Clash: "clash",
          V2Ray: "v2ray",
          Trojan: "trojan",
          ShadowsocksR: "ssr",
          Quantumult: "quan",
          "Quantumult X": "quanx",
          "Shadowsocks(SIP002)": "ss",
          "Shadowsocks Android(SIP008)": "sssub",
          ShadowsocksD: "ssd",
        },
        shortTypes: {
         "suo.wtf":"https://suo.wtf/short",
        },
        customBackend: {
          "本站高速": "p01--con--sub--yz2b-f4cw.code.run/",
        },
        backendOptions: [
          { value: "p01--con--sub--yz2b-f4cw.code.run/" },
        ],
        remoteConfig: [
          {
            label: "PZCN",
            options: [
              {
                label: "国家地区分组",
                value: "https://fastly.jsdelivr.net/gh/pzcn/Clash-profiles@master/country.ini"
              },
              {
                label: "极简分组",
                value: "https://fastly.jsdelivr.net/gh/pzcn/Clash-profiles@master/minimal.ini"
              }
            ]
          },
        ]
      },
      form: {
        sourceSubUrl: "",
        clientType: "",
        customBackend: "p01--con--sub--yz2b-f4cw.code.run/",
        shortType: "https://suo.wtf/short",
        remoteConfig: "",
        excludeRemarks: "",
        includeRemarks: "",
        filename: "",
        rename: "",

        // tpl 定制功能
        tpl: {
          surge: {
            doh: false // dns 查询是否使用 DoH
          },
          clash: {
            doh: false
          }
        }
      },

      loading: false,
      customSubUrl: "",
      curtomShortSubUrl: "",

      dialogUploadConfigVisible: false,
      uploadConfig: "",
      uploadPassword: "",
      myBot: tgBotLink,
      sampleConfig: remoteConfigSample
    };
  },
  created() {
    document.title = "在线订阅转换工具";
    this.isPC = this.$getOS().isPc;
  },
  mounted() {
    this.form.clientType = "api";
    this.getBackendVersion();
    this.anhei();
    let lightMedia = window.matchMedia('(prefers-color-scheme: light)');
    let darkMedia = window.matchMedia('(prefers-color-scheme: dark)');
    let callback = (e) => {
    if (e.matches) {
       this.anhei();
       }
    };
    if (typeof darkMedia.addEventListener === 'function'|| typeof lightMedia.addEventListener === 'function') {
       lightMedia.addEventListener('change', callback);
       darkMedia.addEventListener('change', callback);
    } //监听系统主题，自动切换！
  },
  methods: {
    anhei() {
      const getLocalTheme = window.localStorage.getItem("localTheme");
      const lightMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: light)'); 
      const darkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)'); 
      if (getLocalTheme) {
        document.getElementsByTagName('body')[0].className = getLocalTheme;
      } //读取localstorage，优先级最高！
      else if (getLocalTheme == null || getLocalTheme == "undefined" || getLocalTheme == "") {
      if (new Date().getHours() >= 19 || new Date().getHours() < 7) {
        document.getElementsByTagName('body')[0].setAttribute('class', 'dark-mode');  
      } 
      else {
        document.getElementsByTagName('body')[0].setAttribute('class', 'light-mode');  
      } //根据当前时间来判断，用来对付QQ等不支持媒体变量查询的浏览器
      if (lightMode && lightMode.matches) { 
        document.getElementsByTagName('body')[0].setAttribute('class', 'light-mode');
      } 
      if (darkMode && darkMode.matches) { 
        document.getElementsByTagName('body')[0].setAttribute('class', 'dark-mode');
      } //根据窗口主题来判断当前主题！
     }  
    },  
    change() {
      var zhuti = document.getElementsByTagName('body')[0].className;
      if (zhuti === 'light-mode'){
      document.getElementsByTagName('body')[0].setAttribute('class', 'dark-mode');
      window.localStorage.setItem('localTheme','dark-mode');
      }
      if (zhuti === 'dark-mode'){
      document.getElementsByTagName('body')[0].setAttribute('class', 'light-mode');
      window.localStorage.setItem('localTheme','light-mode');
      }
    },
    onCopy() {
      this.$message.success("Copied!");
    },
    goToProject() {
      window.open(project);
    },
    gotoTgChannel() {
      window.open(tgBotLink);
    },
    gotoGayhub() {
      window.open(gayhubRelease);
    },
    gotoRemoteConfig() {
      window.open(remoteConfigSample);
    },
    clashInstall() {
      if (this.customSubUrl === "") {
        this.$message.error("请先填写必填项，生成订阅链接");
        return false;
      }

      const url = "clash://install-config?url=";
      window.open(
        url +
          encodeURIComponent(
            this.curtomShortSubUrl !== ""
              ? this.curtomShortSubUrl
              : this.customSubUrl
          )
      );
    },
    surgeInstall() {
      if (this.customSubUrl === "") {
        this.$message.error("请先填写必填项，生成订阅链接");
        return false;
      }

      const url = "surge://install-config?url=";
      window.open(url + this.customSubUrl);
    },
    makeUrl() {
      if (this.form.sourceSubUrl === "" || this.form.clientType === "") {
        this.$message.error("订阅链接与客户端为必填项");
        return false;
      }
      if (this.form.sourceSubUrl.indexOf("losadhwse") !== -1 && (this.form.customBackend.indexOf("api.wcc.best") !== -1)) {
        this.$alert("薯条已将该后端屏蔽，请更换其他后端进行转换！",{
        type: "warning",
        confirmButtonText: '确定',
        customClass: 'msgbox',
        showClose: false ,
        });
        return false;
      }

      let backend =
        this.form.customBackend === ""
          ? defaultBackend
          : this.form.customBackend;

      let sourceSub = this.form.sourceSubUrl;
      sourceSub = sourceSub.replace(/(\n|\r|\n\r)/g, "|");

      this.customSubUrl =
        backend +
        this.form.clientType +
        "?url=" +
        encodeURIComponent(sourceSub);

      if (this.advanced === "2") {
        if (this.form.remoteConfig !== "") {
          this.customSubUrl +=
            "&config=" + encodeURIComponent(this.form.remoteConfig);
        }
        if (this.form.excludeRemarks !== "") {
          this.customSubUrl +=
            "&exclude=" + encodeURIComponent(this.form.excludeRemarks);
        }
        if (this.form.includeRemarks !== "") {
          this.customSubUrl +=
            "&include=" + encodeURIComponent(this.form.includeRemarks);
        }
        if (this.form.filename !== "") {
          this.customSubUrl +=
            "&filename=" + encodeURIComponent(this.form.filename);
        }
        if (this.form.rename !== "") {
          this.customSubUrl +=
            "&rename=" + encodeURIComponent(this.form.rename);
        }
        if (this.form.appendType) {
          this.customSubUrl +=
            "&append_type=" + this.form.appendType.toString();
        }

        this.customSubUrl +=
          "&emoji=" +
          this.form.emoji.toString() +
          "&list=" +
          this.form.nodeList.toString() +
          "&udp=" +
          this.form.udp.toString() +
          "&tfo=" +
          this.form.tfo.toString() +
          "&expand=" +
          this.form.expand.toString() +
          "&scv=" +
          this.form.scv.toString() +
          "&fdn=" +
          this.form.fdn.toString() +
          "&sort=" +
          this.form.sort.toString();

        if (this.form.tpl.surge.doh === true) {
          this.customSubUrl += "&surge.doh=true";
        }

        if (this.form.clientType === "clash") {
          if (this.form.tpl.clash.doh === true) {
            this.customSubUrl += "&clash.doh=true";
          }

          this.customSubUrl += "&new_name=" + this.form.new_name.toString();
        }
      }

      this.$copyText(this.customSubUrl);
      this.$message.success("定制订阅已复制到剪贴板");
    },
    makeShortUrl() {
      if (this.customSubUrl === "") {
        this.$message.warning("请先生成订阅链接，再获取对应短链接");
        return false;
      }
      
      let duan =
        this.form.shortType === ""
          ? shortUrlBackend
          : this.form.shortType;
      
      this.loading = true;

      let data = new FormData();
      data.append("longUrl", btoa(this.customSubUrl));

      this.$axios
        .post(duan, data, {
          header: {
            "Content-Type": "application/form-data; charset=utf-8"
          }
        })
        .then(res => {
          if (res.data.Code === 1 && res.data.ShortUrl !== "") {
            this.curtomShortSubUrl = res.data.ShortUrl;
            this.$copyText(res.data.ShortUrl);
            this.$message.success("短链接已复制到剪贴板");
          } else {
            this.$message.error("短链接获取失败：" + res.data.Message);
          }
        })
        .catch(() => {
          this.$message.error("短链接获取失败");
        })
        .finally(() => {
          this.loading = false;
        });
    },
    confirmUploadConfig() {
      if (this.uploadConfig === "") {
        this.$message.warning("远程配置不能为空");
        return false;
      }

      this.loading = true;

      let data = new FormData();
      data.append("password", this.uploadPassword);
      data.append("config", this.uploadConfig);

      this.$axios
        .post(configUploadBackend, data, {
          header: {
            "Content-Type": "application/form-data; charset=utf-8"
          }
        })
        .then(res => {
          if (res.data.Code === 1 && res.data.url !== "") {
            this.$message.success(
              "远程配置上传成功，配置链接已复制到剪贴板，有效期三个月望知悉"
            );

            // 自动填充至『表单-远程配置』
            this.form.remoteConfig = res.data.Url;
            this.$copyText(this.form.remoteConfig);

            this.dialogUploadConfigVisible = false;
          } else {
            this.$message.error("远程配置上传失败：" + res.data.Message);
          }
        })
        .catch(() => {
          this.$message.error("远程配置上传失败");
        })
        .finally(() => {
          this.loading = false;
        });
    },
    backendSearch(queryString, cb) {
      let backends = this.options.backendOptions;

      let results = queryString
        ? backends.filter(this.createFilter(queryString))
        : backends;

      // 调用 callback 返回建议列表的数据
      cb(results);
    },
    createFilter(queryString) {
      return candidate => {
        return (
          candidate.value.toLowerCase().indexOf(queryString.toLowerCase()) === 0
        );
      };
    },
    getBackendVersion() {
      this.$axios
        .get(
          defaultBackend.substring(0, defaultBackend.length - 10) + "/version"
        )
        .then(res => {
          this.backendVersion = res.data.replace(/backend\n$/gm, "");
          this.backendVersion = this.backendVersion.replace("subconverter", "");
        });
    }
  }
};
</script>
