package io.quicktype;

import java.util.Map;
import com.fasterxml.jackson.annotation.*;

public class PurpleGDP {
    private long page;
    private long pages;
    private String perPage;
    private long total;

    @JsonProperty("page")
    public long getPage() { return page; }
    @JsonProperty("page")
    public void setPage(long value) { this.page = value; }

    @JsonProperty("pages")
    public long getPages() { return pages; }
    @JsonProperty("pages")
    public void setPages(long value) { this.pages = value; }

    @JsonProperty("per_page")
    public String getPerPage() { return perPage; }
    @JsonProperty("per_page")
    public void setPerPage(String value) { this.perPage = value; }

    @JsonProperty("total")
    public long getTotal() { return total; }
    @JsonProperty("total")
    public void setTotal(long value) { this.total = value; }
}
