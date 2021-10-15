
## 設定專案 Git 使用者名稱與電子信箱

平常使用同一帳號時，會設定全域的 Git 使用者名稱和電子信箱，而提交紀錄中的提交者也根據此設定來尋找對應的使用者。為了針對不同帳號使用不同的使用者名稱和電子信箱，需要針對專案個別進行設定。這邊介紹兩種方式：

### 針對個別專案設定

```bash
# 下載項目專案
$ git clone git@github.com-work:<USERNAME>/<REPO>.git && cd <REPO>

# 進入專案資料夾設定使用者名稱與電子信箱
$ git config user.name <USERNAME_FOR_WORK>
$ git config user.email <EMAIL_FOR_WORK>
```

### 針對特定目錄設定

為了避免每個項目都要各別設定，建議可以在工作目錄中分別針對個人專案與項目專案建立資料夾：

- `~/WorkSpace/personal`
- `~/WorkSpace/work`

再透過 Git 的設定文件 `~/.gitconfig` 來針對不同目錄設定：

```yaml
# ~/.gitconfig
[user]
  name = <USERNAME>
  email = <EMAIL>

[includeIf "gitdir:~/WorkSpace/work"]
  path = ~/WorkSpace/work/.gitconfig
```

上述設定表示在全域下會採用設定中的使用者名稱與電子信箱，而當目錄為 `~/WorkSpace/work` 時則會載入 `~/WorkSpace/work/.gitconfig` 設定檔：

```yaml
# ~/WorkSpace/work/.gitconfig
[user]
 name = <USERNAME_FOR_WORK>
 email = <EMAIL_FOR_WORK>
```
