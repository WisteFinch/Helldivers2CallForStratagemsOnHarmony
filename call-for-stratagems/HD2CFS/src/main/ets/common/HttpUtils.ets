import util from '@ohos.util'
import { rcp } from '@kit.RemoteCommunicationKit'
import { request } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs'

export async function fetchData(url: string): Promise<string> {
  const request = new rcp.Request(url, 'GET');
  const session = rcp.createSession();
  let res: rcp.Response = await session.fetch(request);
  if (res.statusCode != 200) {
    throw new Error;
  }
  const decoder = util.TextDecoder.create('utf-8');
  return decoder.decodeToString(new Uint8Array(res.body));
}

export async function downloadToFileDir(url: string, dir: string, path: string): Promise<boolean> {
  try {
    if (!await fs.access(getContext().filesDir + dir)) {
      await fs.mkdir(getContext().filesDir + dir);
    }
    if (!await fs.access(getContext().filesDir + path)) {
      await request.downloadFile(getContext(), {
        url: url,
        filePath: getContext().filesDir + path
      }).catch(() => {
        return false;
      });
    }
    return true;
  } catch (err) {
    return false;
  }
}